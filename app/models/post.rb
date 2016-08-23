class Post < ActiveRecord::Base
  require 'tempfile'
  #require 'acts-as-taggable-on'

  def self.MaxUploadSize
    102400 # 100kb
  end

  validate :valid_upload_size
  validates_presence_of :content
  validates_presence_of :content_type
  # not more content then 1MB
  validates_length_of :content, :maximum => Post.MaxUploadSize
  validates_length_of :title, :maximum => 255
  validates_length_of :author, :maximum => 255

  has_many :likedislikes, :dependent => :destroy
  has_many :likes, -> {where liked: true}, :class_name => "Likedislike"
  has_many :dislikes, -> {where liked: false},:class_name => "Likedislike"
  has_many :comments, :dependent => :destroy
  has_many :linecomments, :dependent => :destroy
  has_one :child, :class_name => "Post",
    :foreign_key => :parent_id, :dependent => :destroy
  belongs_to :parent, :class_name => "Post"

  acts_as_taggable

  attr_accessible :tag_list, :title, :author, :content_type, :content

  attr_accessor :uploaded_file

  def self.file_extensions
    { '' => 'Text',
      'rb' => 'Ruby',
      'cs' => 'C#',
      'c' => 'C',
      'h' => 'C',
      'sh' => 'Shell',
      'pl' => 'Perl',
      'diff' => 'Diff',
      'patch' => 'Diff',
      'java' => 'Java',
      'js' => 'JavaScript',
      'py' => 'Python'
    }
  end

  def self.MaxPreviewLines
    10
  end

  def self.feed(last)
    self.includes(:comments, :likes, :dislikes)
      .where("created_at < ? ", last).where(:newest => true)
      .order('created_at desc').limit(20)
  end

  def collect_parent_ids
    if parent.nil?
      return [ self.id ]
    else
      return [ parent_id, self.id ] +  parent.collect_parent_ids
    end
  end

  def all_comments
    Comment.where(:post_id => self.collect_parent_ids).order('created_at desc')
  end

  def create_version(params)
    if self.newest != true
      children_ids = self.children.map{|x| x.id}
      newest_post = Post.where(:id => children_ids, "newest" => true).first
      former_newest_params =  newest_post.serializable_hash
      former_newest_params.delete("id")
      former_newest_params["newest"] = false
      former_newest = self.class.new(former_newest_params)
      former_newest.save
      newest_post.update_attributes(params)
      newest_post.parent_id = former_newest.id
      return newest_post
    else
      old_params = self.serializable_hash
      old_params.delete("id")
      parent = self.class.new(old_params)
      parent.newest = false
      self.newest = true
      parent.save
      self.parent_id = parent.id
      self.update_attributes(params)
      return self
    end
  end

  def self.new_from_file(params, data)
    new_post = self.new
    new_post.title = params[:post][:title].blank? ?
      data.original_filename : params[:post][:title]
    file_content = data.read.force_encoding("UTF-8")
    new_post.content = params[:post][:content]
    new_post.content << file_content
    new_post.content_type = get_content_type(data)
    return new_post
  end

  def valid_upload_size
    if self.content.nil?
      self.errors.add(:upload_file, "no file found")
      return
    end

    if self.content.size > Post.MaxUploadSize
      self.errors.add(:upload_file, "file too large:" +
                       " #{self.content.size / 1024} kb" +
                       " only #{Post.MaxUploadSize} allowd")
    end
  end

  def self.get_content_type(data)
    content_type = 'Text'
    content = data.read.force_encoding("UTF-8")

    Tempfile.open(['uploaded', data.original_filename.downcase],
                  Rails.root.join('tmp')) do |f|
      # set executable bits so Linguist will check for shebangs
      f.chmod(0755)
      f.print(content)
      f.flush
      unless Linguist::FileBlob.new(f.path).language.nil?
        content_type = Linguist::FileBlob.new(f.path).language.name
      end
                  end
    return content_type
  end

  def errors=(errors)
    @errors = errors
  end

  def self.search(search_string)
    return [] if search_string.blank?
    post_arel_table = Post.arel_table
    self.where(
      post_arel_table[:content].matches("%#{search_string}%").or(
      post_arel_table[:title].matches("%#{search_string}%")).or(
      post_arel_table[:author].matches("%#{search_string}%"))).
      order("#{table_name}.created_at desc").includes(:likes, :dislikes,
        :comments).references(:content)
  end

  def diff_to_parent(post_id = nil)
    post_to_diff = Post.find_by_id(post_id) || self.parent
    if post_to_diff
      Diffy::Diff.new(post_to_diff.content, self.content,
        :include_plus_and_minus_in_html => true).to_s(:html)
    else
      ""
    end
  end

  def children
    child = Post.where(:parent_id => self.id).first
    return [] if child.nil?
    return child.children + [child]
  end 

  def parents
    return [] if parent_id.nil?
    return [parent] + parent.parents
  end

  def tag_list_tokens=(tokens)
	self.tag_list = tokens.gsub("'", "")
  end
end
