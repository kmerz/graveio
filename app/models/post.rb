class Post < ActiveRecord::Base

  validates_presence_of :content
  validates_presence_of :content_type
  # not more content then 1MB
  validates_length_of :content, :maximum => 104875
  validates_length_of :title, :maximum => 255
  validates_length_of :author, :maximum => 255
  attr_accessible :content, :title, :author, :content_type

  has_many :comments, :dependent => :destroy
  has_many :likedislikes, :dependent => :destroy
  has_one :child, :class_name => "Post",
    :foreign_key => :parent_id, :dependent => :destroy
  belongs_to :parent, :class_name => "Post", :dependent => :destroy

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
      'js' => 'JavaScript'
    }
  end

  def self.feed(last)
    self.includes(:comments)
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
    child = self.class.new(params)
    child.parent_id = self.id
    self.newest = false
    self.save
    return child
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
      order('created_at desc')
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
