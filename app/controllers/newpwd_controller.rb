class NewpwdController < ApplicationController
  layout "user"
  protect_from_forgery :except => [:createpwd]

  def newpwd 
    @left = "false"
    tick = params[:tick]
    newtick = tick[tick.length-3,tick.length] + tick[0,tick.length-3]
    param = Base64.decode64(newtick).split("$");

    expiredTime = param[1]
    today = Time.now.strftime("%d-%m-%Y")
    if(expiredTime!=nil && today.to_time(:local) < expiredTime.to_time(:local))
      @loginName = param[0]
    else
      flash[:notice] = "This URL has expired! Please try again."
      redirect_to :controller=>"forgetpwd", :action=>"forgetpwd"
    end
  end

  def createpwd
    reset_session()

    loginName = params[:login_name]
    password = params[:pwd1]
    password2 = params[:pwd2]

    if password != password2
      flash[:notice] = "Re-Enter Password  is not consistent with New Password."
      redirect_to :back
    else
      
      @profile = Profile.find(:first, :conditions => ["login_email=?", loginName]) 
     if @profile!=nil 
         @profile.update_attributes(:password=>Digest::MD5.hexdigest(params[:pwd1]))
      
        #���ȫ��ע��ɹ����״̬
        session[:issubmit]= @profile.submit_success
        session[:profile_id] = @profile.id

        @degree=Degree.find_by_profile_id(session[:profile_id])
        if @degree != nil
          session[:startDate] = @degree.start_date
          session[:degree_id] = @degree.id
          redirect_to :controller=>"profile", :action=>"welcome"
        else
          redirect_to :controller=>"degree", :action=>"chooseDegree"
        end
      else
        flash[:notice] = "There is no applicant with the login email "
        redirect_to  :controller=>"newpwd",:action=>"newpwd"
      end
    end

  end
end
