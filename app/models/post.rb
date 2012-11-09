class Post < ActiveRecord::Base
  validates_presence_of :content
  # not more content then 1MB
  validates_length_of :content, :maximum => 104875
  validates_length_of :title, :maximum => 255
  attr_accessible :content, :title

  has_many :comments, :dependent => :destroy

  def self.feed(last)
    self.where("created_at < ? ", last).order('created_at desc').limit(20)
  end

  def self.search(search_string)
    return [] if search_string.blank?
    post_arel_table = Post.arel_table
    self.where(post_arel_table[:content].matches("%#{search_string}%").or(
      post_arel_table[:title].matches("%#{search_string}%"))).
        order('created_at desc')
  end
end
