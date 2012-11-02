class Post < ActiveRecord::Base
  validates_presence_of :content
  attr_accessible :content, :title
end
