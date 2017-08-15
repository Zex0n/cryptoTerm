class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  helper_method :trade_path_with_username

  rescue_from CanCan::AccessDenied do |exception|
    Rails.logger.debug "Access denied on #{exception.action} #{exception.subject.inspect}"
    exception.default_message = t 'unauthorized.default_message'

    respond_to do |format|
      format.html { render 'templates/error', :status => 403, :locals => { :message => exception.message }, \
                                              :layout => (controller_name != 'main')  }
      format.js { render json: { header: "Access denied.", message: exception.message }, status: 403 }
    end
  end

  def index
    if signed_in?
      redirect_to trades_path(username: current_user.username)  
    else
      render 'templates/index'
    end
  end

  protected

  def trade_path_with_username(trade)
    trade_path(id: trade.id, username: trade.user.username.downcase)
  end

  def respond_with_invalid_key(key_name)
    respond_to do |format|
      format.html { redirect_to :back, alert: "API key '#{key_name}' is invalid." }
      format.js { render json: { header: "Invalid API key.", message: "API key '#{key_name}' is invalid." }, status: 403}
    end
  end

  def require_admin!
    current_user and current_user.role == 'admin' # unless Rails.env.development?
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:username, :email, :password, :password_confirmation, :remember_me) }
    devise_parameter_sanitizer.permit(:sign_in) { |u| u.permit(:username, :login, :username, :email, :password, :remember_me) }
    devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:username, :email, :password, :password_confirmation, :current_password) }
  end


  def messages_to_list(errors)
    li = errors.map{ |e| content_tag(:li, e) }.join("\n").html_safe
    content_tag(:ul, li)
  end


end
