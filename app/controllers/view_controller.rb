class ViewController < ApplicationController
  before_filter:authorize
  layout "user"
  protect_from_forgery :except => [:insert]

  def view
  @left = "false"
    if session[:profile_id] != nil
      @profile = Profile.find_by_id(session[:profile_id])
      @degree = Degree.find_by_profile_id(session[:profile_id])
      @academics = Academic.find_all_by_profile_id(session[:profile_id])
      @careerinfo = Careerinfo.find_by_profile_id(session[:profile_id])
      @references = ReferenceInfo.find_all_by_profile_id(session[:profile_id])
      @transcript = Transcript.find(:first, :conditions => ["profile_id = ?  and sign_type = 0", session[:profile_id].to_s])
    end
  end

end
