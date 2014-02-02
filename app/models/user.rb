class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_one :apikey

  def add_new_api_key
    if self.apikey.present?
      self.apikey.destroy
    end
    api_key = Apikey.new
    api_key.user_id = self.id
    api_key.save

    self.apikey_id = api_key.id
    self.save
  end
end
