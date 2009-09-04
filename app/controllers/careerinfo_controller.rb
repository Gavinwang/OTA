class CareerinfoController < ApplicationController
  before_filter:authorize
  layout "user"
  protect_from_forgery :except => [:careerinfo, :create]

  def careerinfo
    @titlelogo = "employment";
    
    @profile = Profile.find_by_id(session[:profile_id])
    if (session[:careerinfo_id]==nil)

      @careerinfo = Careerinfo.find_by_profile_id(session[:profile_id])
      if  @careerinfo != nil
        session[:careerinfo_id] = @careerinfo.id
      end

    else
      @careerinfo = Careerinfo.find_by_id(session[:careerinfo_id])
    end

  end

  #���������careerinfo
  def create
    if !session[:careerinfo_id]

      @careerinfo = Careerinfo.new(params[:careerinfo])
      @careerinfo.profile_id = session[:profile_id]
      if(params["careerinfo"]["state2"]=="0")
        Careerinfo.validatesfirst    
      end
      if @careerinfo.save
        session[:c]=1
        session[:careerinfo_id] = @careerinfo.id
        redirect_to :controller => "reference_info", :action=>"reference_info"
      else
        flash[:notice] = "Career Information was failed to created."
        logger.error("Career Information was failed to update : !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! at:"+ Time.new.to_s)
        @titlelogo = "employment";
        render :action=> :careerinfo
      end

    else

      @careerinfo = Careerinfo.find_by_id(session[:careerinfo_id])
      @careerinfo.profile_id = session[:profile_id]
      if(params["careerinfo"]["state2"]=="0")
        Careerinfo.validatesfirst
      end
      if @careerinfo.update_attributes(params[:careerinfo])
        redirect_to :controller => "reference_info", :action=>"reference_info"
      else
         flash[:notice] = "Career Information was failed to update."
         logger.error("Career Information was failed to update : !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! at:"+ Time.new.to_s)
        @titlelogo = "employment";
        render :action=> :careerinfo
      end

    end

  end

end
