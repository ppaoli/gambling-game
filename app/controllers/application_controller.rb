class ApplicationController < ActionController::Base
  include Pundit
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :gender, :mobile_number, address_attributes: [:country, :state, :city, :street, :postal_code]])
  end

  def authenticate_admin!
    unless current_user && current_user.admin?
      redirect_to root_path, alert: "You must be an admin to perform this action."
    end
  end
end
