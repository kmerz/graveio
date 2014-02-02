class Apikey < ActiveRecord::Base
  belongs_to :apikey
  before_create :generate_api_key

  def generate_api_key
    self.key = Base64.encode64(OpenSSL::Random.random_bytes(33)).chomp
  end
end
