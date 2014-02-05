class Post < ActiveRecord::Base
  require 'tempfile'

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

  has_many :post_tags
  has_many :tags, :through => :post_tags
  has_many :likedislikes, :dependent => :destroy
  has_many :likes, -> {where liked: true}, :class_name => "Likedislike"
  has_many :dislikes, -> {where liked: false},:class_name => "Likedislike"
  has_many :comments, :dependent => :destroy
  has_many :linecomments, :dependent => :destroy
  has_one :child, :class_name => "Post",
    :foreign_key => :parent_id, :dependent => :destroy
  belongs_to :parent, :class_name => "Post"

  attr_accessor :uploaded_file, :input_tags

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

  def link_tag(name)
    tag = Tag.find_or_create_by(:name => name)
    post_tag = self.post_tags.find_or_create_by(
      :post_id => self.id,
      :tag_id => tag.id)
  end

  def create_version(params)
    child = self.class.new(params)
    child.parent_id = self.id
    self.newest = false
    self.save
    return child
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

  def diff_to_parent(parent_id = nil)
    post_to_diff = Post.find_by_id(parent_id) || self.parent
    if post_to_diff
      Diffy::Diff.new(post_to_diff.content, self.content,
        :include_plus_and_minus_in_html => true).to_s(:html)
    else
      ""
    end
  end
end
