class ApplicationController < ActionController::Base
  
  # Adds a few additional behaviors into the application controller
   include Blacklight::Controller
  # Please be sure to impelement current_user and user_session. Blacklight depends on
  # these methods in order to perform user specific actions.

  include Authpds::Controllers::AuthpdsController
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
