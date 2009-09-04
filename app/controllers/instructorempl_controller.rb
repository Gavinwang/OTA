class InstructoremplController < ApplicationController

  layout "user"
  protect_from_forgery :except => [:index, :create, :update, :success]

  def index
    @left = "false"
  end

  def create
    @left = "false"

    @insempl = InstructorEmployment.new(params[:instructor_employment])
    InstructorEmployment.validatesFirst

    @indivdual_1 = Individual.new(params[:individual_1])
    @indivdual_2 = Individual.new(params[:individual_2])
    @indivdual_3 = Individual.new(params[:individual_3])

    @insempl.individuals << @indivdual_1
    @insempl.individuals << @indivdual_2
    @insempl.individuals << @indivdual_3

    begin
      if @insempl.save!
        session[:ins_id] = @insempl.id
        redirect_to :action => "update"
      end
    rescue Exception => e
      logger.error("Instructor employment information was failed to create : !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! at:"+ Time.new.to_s)
      logger.error(e)
      flash[:notice] = "Instructor employment information was failed to create with exception: #{e}"     
      render :action=>"index"
    end
    
  end

  def update
    @left = "false"
    @insempl = InstructorEmployment.find_by_id(session[:ins_id])

  end

  def success
    @left = "false"
    @insempl = InstructorEmployment.find_by_id(session[:ins_id])
    InstructorEmployment.validatesSecond
    if @insempl.update_attributes(params[:instructor_employment])
      individuals = Individual.find(:all,:conditions => ["instructor_employment_id = ?" ,@insempl.id])
      begin
        Notifier.deliver_applicant_ota(@insempl)
        Notifier.deliver_admin_ota(@insempl,individuals)
      rescue Exception => e
        flash[:notice] = "#{e}"
      end
      #flash[:message] = "Application for Online Instructor Employment register successful.<br/><br/>"
    else
      render :action=> :update
    end
  end
end
