class DegreeController < ApplicationController
  before_filter:authorize
  layout "user"
  protect_from_forgery :except => [:chooseDegree, :create, :changeStartDate]

  def chooseDegree
    @left = "false"
    @massage = params[:message]
  end
  #����degree
  def create
    @left = "false"

    if params["degree"]["start_date"]==""
              flash[:notice] = "<ul style='color: Red;'><li>Choose a Start Date.</li></ul>"
        redirect_to :action=>:chooseDegree and return false
    end

    if session[:degree_id]
      @degree = Degree.find_by_id(session[:degree_id])
      if @degree.update_attributes(params[:degree])
        session[:startDate] = @degree.start_date
        redirect_to :controller => "profile", :action=>"success"
      else
        flash[:notice] = "<ul style='color: Red;'><li>Degree infomation was failed to create.</li></ul>"
        logger.error("Degree infomation was failed to create : !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! at:"+ Time.new.to_s)
        render :action=> :chooseDegree and return false
      end
    else
      @degree = Degree.new(params[:degree])
      @degree.profile_id = session[:profile_id]
      if @degree.save
        session[:d]=1
        session[:startDate] = @degree.start_date
        session[:degree_id] = @degree.id

        @profile = Profile.find_by_id(session[:profile_id])
        begin
          Notifier.deliver_applicant_profile_create(@profile)
          Notifier.admin_profile_created(@profile,@degree)
        rescue Exception => e
          flash[:notice] = "Notifier email was failed to send and the exception is #{e}"
          logger.error("Notifier email sending failed : !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! at:"+ Time.new.to_s)
          logger.error e.message
        end 
        redirect_to :controller => "profile", :action=>"success"
      else
        logger.error("Degree infomation was failed to create : !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! at:"+ Time.new.to_s) 
        flash[:notice] = "<ul style='color: Red;'><li>Degree infomation was failed to create.</li></ul>"
        render :action=> :chooseDegree
      end
    end
  end
  
  #�޸�star date
  def changeStartDate
       @degree = Degree.find_by_profile_id(session[:profile_id])
      if @degree.update_attributes(:start_date=>params[:start_date])
         session[:startDate] = params[:start_date]
      end
      flash[:date_change_notice] = "<span id='flash' style='color: Red;'>Strat Date has been changed successfully.</span><br>"
      redirect_to :back
  end

end
