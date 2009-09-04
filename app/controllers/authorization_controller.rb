class AuthorizationController < ApplicationController
  before_filter:authorize
  layout "user"
  protect_from_forgery :except => [:authorization, :save]

  def authorization
    @transcript = Transcript.find(:first, :conditions => ["profile_id = ?  and sign_type = 1", session[:profile_id].to_s])
  end

  #��֤ĳ��������δ��д,����д�󱣴�
  def save
    @profile = Profile.find_by_id(session[:profile_id])
    @academic = Academic.find_by_profile_id(session[:profile_id])
    @careerinfo = Careerinfo.find_by_profile_id(session[:profile_id])
    #@reference = ReferenceInfo.find_by_profile_id(session[:profile_id])
    if  @profile.con_name == nil
      flash[:hint] = "Please check the following section(s). <br/>Required information is missing or incomplete. <br/>* Personal Information"
      redirect_to :back
    elsif @academic == nil
      flash[:hint] = "Please check the following section(s). <br/>Required information is missing or incomplete. <br/>* Academic Information"
      redirect_to :back
    elsif @careerinfo == nil
      flash[:hint] = "Please check the following section(s). <br/>Required information is missing or incomplete. <br/>* Career Information"
      redirect_to :back
    #elsif @reference == nil
    #  flash[:hint] = "Please check the following section(s). <br/>Required information is missing or incomplete. <br/>* Upload and Download Information"
    #  redirect_to :back
    else
      @transcript = Transcript.new
      if (params[:date]!="" && params[:signature]!="")
        @transcript.sign_type = 1
        @transcript.date = params[:date]
        @transcript.signature = params[:signature]
        @transcript.profile_id = session[:profile_id]
        if @transcript.save
          @profile.update_attribute(:submit_success, 1)
          session[:issubmit] = 1
          begin
            Notifier.deliver_applicant_profile_submit(@profile)
            Notifier.admin_application_submit(@profile, @transcript)
          rescue Exception => e
            logger.error("Notifier email was failed to send : !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! at:"+ Time.new.to_s)
            logger.error(e)
            flash[:notice] = "Notifier email was failed to send and the exception is #{e}"        
          end
          redirect_to :controller=>"/authorization/success"
        end
      else
        flash[:notice] = "Please write the signature first."  
        redirect_to :controller=>"/authorization/authorization"
      end
    end


  end

  def success

  end

end
