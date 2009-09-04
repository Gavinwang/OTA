class AcademicController < ApplicationController
  before_filter:authorize
  layout "user"
  protect_from_forgery :except => [:academic, :create]

  #��ѯ�Ƿ���academic�ļ�¼
  def academic
    @titlelogo = "academic";
    @profile = Profile.find_by_id(session[:profile_id])
    @profile.user_type == 0 ? session[:isdom] = true : session[:isdom] = false
    @country = Country.find(:all)

    @transcript = Transcript.find(:first, :conditions => ["profile_id = ?  and sign_type = 0", session[:profile_id].to_s])

    if session[:academic_id_1] == nil
      @academic_1 = Academic.find(:first, :conditions => ["profile_id = ?  and flag = 1", session[:profile_id].to_s])
      if @academic_1
        session[:academic_id_1] = @academic_1.id
      end

      @academic_2 = Academic.find(:first, :conditions => ["profile_id = ?  and flag = 2", session[:profile_id].to_s])
      if @academic_2
        session[:academic_id_2] = @academic_2.id
      end

      @academic_3 = Academic.find(:first, :conditions => ["profile_id = ?  and flag = 3", session[:profile_id].to_s])
      if @academic_3
        session[:academic_id_3] = @academic_3.id
      end
    else
      @academic_1 = Academic.find_by_id(session[:academic_id_1])
      @academic_2 = Academic.find_by_id(session[:academic_id_2])
      @academic_3 = Academic.find_by_id(session[:academic_id_3])
    end
  end

  #����transcript��academic
  def create
    @profile = Profile.find_by_id(session[:profile_id])
    @profile.user_type == 0 ? session[:isdom] = true : session[:isdom] = false  
    @transcript = Transcript.find(:first, :conditions => ["profile_id = ?  and sign_type = 0", session[:profile_id].to_s])

    #���»򱣴�transcript
    if @transcript
      date = params[:date]
      signature = params[:signature]
      complete_bottom = params[:complete_bottom]
      @transcript.update_attributes(:date => date, :signature => signature, :complete_bottom=>complete_bottom)
    else
      @transcript = Transcript.new
      @transcript.sign_type = 0
      @transcript.profile_id = session[:profile_id]
      @transcript.date = params[:date]
      @transcript.signature = params[:signature]
      @transcript.complete_bottom = params[:complete_bottom]
      @transcript.save
    end

    @country = Country.find(:all)

    div2 = params[:div2]
    div3 = params[:div3]
    saveDiv1 = true
    saveDiv2 = true
    saveDiv3 = true

    if !session[:academic_id_1]
      @academic_1 = Academic.new(params[:academic_1])
      if @academic_1 != nil
        @academic_1.profile_id = session[:profile_id]
        @academic_1.flag = 1
      end
    else
      saveDiv1 = false
      @academic_1 = Academic.find_by_id(session[:academic_id_1])
    end

    if div2 == "true"
      if !session[:academic_id_2]
        @academic_2 = Academic.new(params[:academic_2])
        if @academic_2 != nil
          @academic_2.profile_id = session[:profile_id]
          @academic_2.flag = 2
        end
      else
        saveDiv2 = false
        @academic_2 = Academic.find_by_id(session[:academic_id_2])
      end
    end

    if div3 == "true"
      if !session[:academic_id_3]
        @academic_3 = Academic.new(params[:academic_3])
        if @academic_3 != nil
          @academic_3.profile_id = session[:profile_id]
          @academic_3.flag = 3
        end
      else
        saveDiv3 = false
        @academic_3 = Academic.find_by_id(session[:academic_id_3])
      end
    end

    #���� ��һ��academic��֤��ͨ��,ȫ���ع�
    begin
      Academic.transaction do
        if(@profile.user_type == 1)
          Academic.validatesfirst
        end
        if (!saveDiv1)
          if @academic_1.update_attributes(params[:academic_1])
          else
            raise
          end
        else
          @academic_1.save!
          saveSuccess1 =true
        end

        if div2 == "true"
          if (!saveDiv2)
            if @academic_2.update_attributes(params[:academic_2])
            else
              raise
            end
          else
            @academic_2.save!
            saveSuccess2 =true
          end
        end

        if div3 == "true"
          if (!saveDiv3)
            if @academic_3.update_attributes(params[:academic_3])
            else
              raise
            end
          else
            @academic_3.save!
            saveSuccess3 =true
          end
        end
        if saveSuccess1
          session[:academic_id_1] = @academic_1.id
        end
        if div2 == "true"
          if saveSuccess2
            session[:academic_id_2] = @academic_2.id
          end
        end
        if div3 == "true"
          if saveSuccess3
            session[:academic_id_3] = @academic_3.id
          end
        end
        session[:a]=1
        redirect_to :controller => "careerinfo", :action=>"careerinfo"
      end
    #����Ĵ������  
    rescue Exception => e
      logger.error("Create acdemic error : !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! at:"+ Time.new.to_s)
      logger.error e.message
      flash[:notice] = "Academic Information was failed to created. The exception is " + e.message
      @titlelogo = "academic";
      @profile = Profile.find_by_id(session[:profile_id]) 
      render :action=> :academic
    end
  end
end
