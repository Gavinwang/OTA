class LoginController < ApplicationController
  layout "user"
  protect_from_forgery :except => [:login]
  
  #��ʼ����¼ҳ
  def index
    @left = "false"
    @loginName = params[:loginName] 
    profileid= session[:profile_id]
    if profileid != nil
    @profile = Profile.find(:first, :conditions => ["id=? ", session[:profile_id]]) 
    if @profile!=nil   
      @degree=Degree.find_by_profile_id(session[:profile_id])
      if @degree != nil 
        if(@profile.submit_success ==1)
          redirect_to :controller=>"profile", :action=>"review" and return false 
        end
        redirect_to :controller=>"profile", :action=>"welcome"
      else
        redirect_to :controller=>"degree", :action=>"chooseDegree"
      end
    end
   end 
  end

  # ��¼
  def login
    reset_session() 
    loginName = params[:login_name]
    password = params[:password]
    passwordMD5 = Digest::MD5.hexdigest(password)

    @profile = Profile.find(:first, :conditions => ["login_email=? and password =?", loginName, passwordMD5])
 
    if @profile!=nil
      #���ȫ��ע��ɹ����״�?      session[:issubmit]= @profile.submit_success
      session[:profile_id] = @profile.id

      @degree=Degree.find_by_profile_id(session[:profile_id])
      if @degree != nil
        session[:startDate] = @degree.start_date
        session[:degree_id] = @degree.id
        if(@profile.submit_success ==1)
          redirect_to :controller=>"profile", :action=>"review" and return false 
        end
        redirect_to :controller=>"profile", :action=>"welcome"
      else
        redirect_to :controller=>"degree", :action=>"chooseDegree"
      end
    else
      if loginName ==""
        flash[:notice] = "<ul style='color: Red;'><li>Username is Required.</li></ul>"
        redirect_to :action=>index and return false
      end
      if password ==""
        flash[:notice] = "<ul style='color: Red;'><li>Password is Required.</li></ul>"
        redirect_to :action=>index,
                    :loginName => loginName and return false
      end
      flash[:notice] = "<ul style='color: Red;'><li>Profile not found.</li></ul>"
      redirect_to :action=>index,
                  :loginName => loginName and return false
    end
  end
  #�ǳ��?  
  def logout
    reset_session() 
    flash[:notice] = "<ul style='color: Red;'><li>Logged out.</li></ul>"
    redirect_to :controller=>"login", :action=>"index"
  end

end
