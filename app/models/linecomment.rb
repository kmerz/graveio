class Linecomment < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :post
  attr_accessible :body, :commenter, :line
  validates_presence_of :body
  validates_presence_of :line
end
