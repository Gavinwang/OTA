# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  def isEquals(object1, object2)
    if (object1 == object2)
      return true
    end
  end

  def authorize
    unless session[:profile_id]
        flash[:notice] = "<ul style='color: Red;'><li>Please log in.</li></ul>";
        redirect_to :controller=>"login", :action=>"index"
    end
  end
  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
end
