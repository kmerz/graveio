class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def generate_apikey
    self.api_key = Base64.encode64(OpenSSL::Random.random_bytes(33)).chomp
    self.save
  end

end
