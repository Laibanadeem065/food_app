class ApplicationController < ActionController::Base
   protect_from_forgery with: :exception

   before_action :configure_permitted_parameters, if: :devise_controller?
    include Pundit::Authorization

    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
    def user_not_authorized
      flash[:alert] = "You are not authorized to perform this action."
      redirect_to(root_path)
    end
    

    helper_method :current_cart

    def current_cart
      if current_user
        @current_cart ||= Cart.find_or_create_by(user: current_user)
      else
        session_id = session[:custom_session_id] || generate_session_id
        session[:custom_session_id] ||= session_id
    
        @current_cart ||= Cart.find_or_create_by(session_id: session_id, user_id: nil)
      end
    end



    protected
  
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_in, keys: [:email, :password])
      devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :password, :password_confirmation, :first_name, :last_name])
    end
end
