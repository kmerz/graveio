class Users::RegistrationsController < Devise::RegistrationsController

  def create
    super
    unless current_user.nil?
      current_user.generate_api_key
    end
  end

end
