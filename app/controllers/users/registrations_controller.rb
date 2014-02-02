class Users::RegistrationsController < Devise::RegistrationsController

  def create
    super
    unless current_user.nil?
      current_user.add_new_api_key
    end
  end

end
