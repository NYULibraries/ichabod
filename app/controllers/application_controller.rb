class ApplicationController < ActionController::Base

  include Nyulibraries::Assets::InstitutionsHelper
  # Adds a few additional behaviors into the application controller
   include Blacklight::Controller
  # Please be sure to impelement current_user and user_session. Blacklight depends on
  # these methods in order to perform user specific actions.

  def new_session_path(scope)
    login_path
  end

  # After signing out from the local application,
  # redirect to the logout path for the Login app
  def after_sign_out_path_for(resource_or_scope)
    if ENV['SSO_LOGOUT_URL'].present?
      ENV['SSO_LOGOUT_URL']
    else
      super(resource_or_scope)
    end
  end

  layout Proc.new{ |controller| (controller.request.xhr?) ? false : "application" }

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def current_user_dev
    @current_user ||= User.new(:email => "user@nyu.edu", :firstname => "Ptolemy", :username => "ppXX")
  end

  alias_method :current_user, :current_user_dev if Rails.env.development?

  rescue_from CanCan::AccessDenied do |exception|
    flash[:notice] ||= exception.message.html_safe
    redirect_to root_url
  end
  
end
