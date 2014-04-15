class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  layout :layout_by_resource
  before_filter :configure_permitted_parameters, if: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, error: "Access denied!"
  end

  protected

  def configure_permitted_parameters
    # Only add some parameters
    # Override accepted parameters
    devise_parameter_sanitizer.for(:accept_invitation) do |u|
      u.permit(:password, :password_confirmation,
             :invitation_token)
    end
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:email, :password, :password_confirmation ) }

  end

  def layout_by_resource
    if devise_controller?
      'admin'
    else
      'application'
    end
  end

  def is_admin
    current_user.admin? if current_user
  end

  def after_sign_in_path_for(resource)
    if session[:topic_id]
      topic_contents_path session[:topic_id]
    else
      if current_user.admin?
        admin_levels_path
      else
        if resource && resource.sign_in_count == 1
          new_user_profile_path(resource)
        else
          user_path(current_user)
        end
      end
    end
  end
end
