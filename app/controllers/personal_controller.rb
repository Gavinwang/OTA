class PersonalController < ApplicationController
  before_filter:authorize
  layout "user"
  protect_from_forgery :except => [:personal,:update]

  def personal
    @titlelogo = "personal";
    @country = Country.find(:all)
    @profile = Profile.find_by_id(session[:profile_id])
  end

  #����profile
  def update
    @country = Country.find(:all)
    @profile = Profile.find_by_id(session[:profile_id])
    #��֤profile name,mailing info ,permant info,birthday format  
    Profile.validatessecond
    if(params["profile"]["primary"] == "1")
      Profile.validatesHomePhone
      end
    if(params["profile"]["primary"] == "2")
      Profile.validatesMobilePhone
      end
    if(params["profile"]["primary"] == "3")
      Profile.validatesWorkPhone  
    end
    if @profile.user_type==1
      #��֤social security number ,birth date, us military veteran
      Profile.validatesThird
    end
    if @profile.user_type==0
     #��֤mail country,birth country,citizenship 
     Profile.validatesFive
    end
    if @profile.update_attributes(params[:profile])
      session[:p]=1
      redirect_to :controller => "academic", :action=>"academic"
    else
       flash[:notice] = "Personal Information was failed to created."
       logger.error("Personal Information was failed to created: !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! at:"+ Time.new.to_s) 
      @titlelogo = "personal";
      render :action=> :personal
    end                                                       
  end
end
