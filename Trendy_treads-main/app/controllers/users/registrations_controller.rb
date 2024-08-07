class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters, if: :devise_controller?

  private

  # Configure the permitted parameters for sign up and account update
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [
      :username, :email, :password, :password_confirmation, 
      :first_name, :last_name, 
      address_attributes: [:street, :city, :province_id, :postal_code]
    ])
    devise_parameter_sanitizer.permit(:account_update, keys: [
      :username, :email, :password, :password_confirmation, :current_password,
      :first_name, :last_name, 
      address_attributes: [:street, :city, :province_id, :postal_code]
    ])
  end
end
