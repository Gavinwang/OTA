class ProfileController < ApplicationController
  layout "user"
  protect_from_forgery :except => [:index, :create, :welcome, :review, :success, :changePassword]

  def index
    @massage = params[:message]
    @left = "false"

  end

  #�����ʺ�
  def create
    @left = "false"
    reset_session();
    
    @citizenship = params[:studenttype]
    #��֤�ʼ���ʽ,����
    Profile.validatesFirst
    passwordf = params["profile"]["password"]
    params["profile"]["password"] = Digest::MD5.hexdigest(params["profile"]["password"])

    @profile = Profile.new(params[:profile])

    #0Ϊdom,1Ϊint
    if @citizenship == "0"
      session[:isdom] = true
      @profile.user_type = 0
    else
      session[:isdom] = false
      @profile.user_type = 1
    end
    if @profile.save
      #p=personal  a=academic  c=career  r=reference ,�ж�������Ƿ�����޸�
      session[:p]=0
      session[:a]=0
      session[:c]=0
      session[:r]=0 
      
      @profile.password= passwordf
      session[:profile_id] = @profile.id
      redirect_to :controller=>"degree", :action=>"chooseDegree"
    else
      flash[:notice] = "Profile Information was failed to created."
      logger.error("Profile Information was failed to created: !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! at:"+ Time.new.to_s)  
      render :action=> :index
    end

  end

  #ת��welcomeҳ
  def welcome
    @titlelogo = "welcome";
    @profile = Profile.find_by_id(session[:profile_id])
    @profile.user_type == 0 ? session[:isdom] = true : session[:isdom] = false
    @academics = Academic.find_all_by_profile_id(session[:profile_id])
    @careerinfo = Careerinfo.find_by_profile_id(session[:profile_id])
    @references = ReferenceInfo.find_all_by_profile_id(session[:profile_id])
    @transcript = Transcript.find(:first, :conditions => ["profile_id = ?  and sign_type = 0", session[:profile_id].to_s])
    @degree = Degree.find_by_profile_id(session[:profile_id])
    #��¼����ʾview
    @profile.con_name == nil ? session[:p]=0 : session[:p]=1
    @academics.empty? ? session[:a]=0 : session[:a]=1
    @careerinfo == nil ? session[:c]=0 : session[:c]=1
    @references.empty? ? session[:r]=0 : session[:r]=1
    @degree == nil ? session[:d]=0 : session[:d]=1
  end

  #ת��reviewҳ
  def review
    @titlelogo = "review";
  end

  def success
    @left = "false"
  end

  #�ǳ�
  def logout
    reset_session()
    redirect_to :controller=>"login", :action=>"index"
  end

  #�޸�����
  def changePassword
    @profile = Profile.find_by_id(session[:profile_id])
    @profile.update_attributes(:password=>Digest::MD5.hexdigest(params[:newPassword]))
    flash[:change_pass_notice] = "<span id='flash' style='color: Red;'>Password has been changed successfully.</span><br>"
    redirect_to :back
  end
end
