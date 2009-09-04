class ForgetpwdController < ApplicationController
  #before_filter:authorize
  layout "user"
  protect_from_forgery :except => [:retrievepwd]

  def forgetpwd
    @left = "false"
  end

  def retrievepwd
    @left = "false"
    if params[:login_name] != nil && params[:login_name] != ""
      @profile = Profile.find(:first, :conditions => ["login_email = ? ", params[:login_name].to_s]);
      if @profile
        email = @profile.login_email
        expiredTime = (Time.now + 86400*4).strftime("%d-%m-%Y")
        tick = Base64.encode64(email + "$" + expiredTime)
        newtick = tick[3, tick.length] + tick[0, 3]
        begin
          Notifier.deliver_forgot_password(@profile,newtick)
        rescue Exception => e
          logger.error("Notifier email was failed to send : !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! at:"+ Time.new.to_s)
          logger.error(e)
          flash[:notice] = "Notifier email was failed to send and the exception is #{e}"
        end
        flash[:message] = "The instruction of resetting your password has been emailed to you.<br/><br/>"
        redirect_to :controller=>"login", :action=>"index"

      else
        flash[:exist] ="Email Address doesn't exist.<br/>"
        redirect_to :back
      end

    else
      #falsh[:email_error] = ""
      redirect_to :back
    end
  end
end
