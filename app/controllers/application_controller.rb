class ApplicationController < ActionController::Base
  protect_from_forgery
  
  #before_filter :authenticate
  #filter_parameter_logging "password"

  protected
  def authenticate
    unless session[:person]
      false
    end
  end
  
end
