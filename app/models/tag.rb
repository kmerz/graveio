class Tag < ActiveRecord::Base
  before_create :downcase_all

  validates_uniqueness_of :name, :case_sensitive => false
  validates_format_of :name, :with => /\A[-a-zA-Z0-9]+\Z/

  has_many :post_tags
  has_many :posts, :through => :post_tags


  private
    def downcase_all
      self.name.downcase!
    end
end
