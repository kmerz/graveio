class Post < ActiveRecord::Base
  validates_presence_of :content
  # not more content then 1MB
  validates_length_of :content, :maximum => 104875
  validates_length_of :title, :maximum => 255
  attr_accessible :content, :title

  def self.feed(last)
    self.where("created_at < ? ", last).order('created_at desc').limit(20)
  end
end
