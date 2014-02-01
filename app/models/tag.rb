class Tag < ActiveRecord::Base

  validates_uniqueness_of :name

  has_many :post_tags
  has_many :posts, :through => :post_tags
end
