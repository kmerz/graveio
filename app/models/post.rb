class Post < ActiveRecord::Base
  validates_presence_of :content
  attr_accessible :content, :title

  def self.feed(last)
    self.where("created_at < ? ", last).order('created_at desc').limit(20)
  end
end
