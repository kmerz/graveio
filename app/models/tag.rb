class Tag < ActiveRecord::Base

  validates_uniqueness_of :name, :case_sensitive => false
  validates_format_of :name, :with => /\A[-a-zA-Z0-9]+\Z/

  has_many :post_tags
  has_many :posts, :through => :post_tags
end
