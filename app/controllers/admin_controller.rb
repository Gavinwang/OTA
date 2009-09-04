class AdminController < ApplicationController
  layout "user"
  protect_from_forgery :except => [:admin, :search]

  def admin
    @left = "false"
    #jin ri zhuce tongji
    @count = Profile.count("id", :conditions  => ["created_at like ?", (Time.now).strftime("%Y-%m-%d")+"%"])

    sql=""
    @mail = ""
    @next = 1
    @prve = 0

    #@year_s = params[:start_date][:"s(1i)"]
    #@month_s = params[:start_date][:"s(2i)"]
    #@day_s = params[:start_date][:"s(3i)"]
    #
    #@year_e = params[:end_date][:"e(1i)"]
    #@month_e = params[:end_date][:"e(2i)"]
    #@day_e = params[:end_date][:"e(3i)"]

    #, :default => {:year => @year_s, :month => @month_s, :day => @day_s}
    #, :default => {:year => @year_e, :month => @month_e, :day => @day_e}
    email = params[:email]
    if email == nil
      email = ""
    end
    @mail =  email
    start = params[:start]

    if start == nil
      start = ""
    end
    @ss = start
    eend = params[:eend]
    if eend == nil
      eend = ""
    end
    @ee = eend
    if email != ""
      sql = "login_email = '" + email +"'"
      if start != "" && eend == ""
        sql += " and created_at >= '" + start + "%'"
      elsif start == "" && eend != ""
        sql += " and created_at <= '" + eend + "%'"
      elsif start != "" && eend != ""
        sql += " and created_at >= DATE('" + start +" 00:00:00') and created_at <= DATE('" + eend + " 23:59:59')"
      end
    else
      if start != "" && eend == ""
        sql = "created_at >= '" + start +"%'"
      elsif start == "" && eend != ""
        sql = "created_at <= '" + eend +"%'"
      elsif start != "" && eend != ""
        if start == eend
          sql = "created_at like '" + start +"%'"
        elsif start != eend
          sql = "created_at >= DATE('" + start +" 00:00:00') and created_at <= DATE('" + eend + " 23:59:59')"
        end
      elsif start == "" && eend == ""
        sql = "1=1"
      end
    end

    if start != "" || eend != ""
      @year_s = start[0, 4]
      @month_s = start[5, 2]
      @day_s = start[8, 2]
      @year_e = eend[0, 4]
      @month_e = eend[5, 2]
      @day_e = eend[8, 2]
    else
      @year_s = Time.new.year
      @month_s = Time.new.month
      @day_s = Time.new.day - 1
      @year_e = Time.new.year
      @month_e = Time.new.month
      @day_e = Time.new.day
    end

    page_limit = 15

    if !params[:flag]
      @page_offset = 0
    else
      @page_offset = params[:offset].to_i
      if params[:flag] == "1"
        @page_offset += 1
      end
      if params[:flag] == "0" && @page_offset > 0
        @page_offset -= 1
      end
    end
    if @page_offset > 0
      @prve = 1
    end

    if sql != ""
      @profiles = Profile.find(:all, :conditions => sql, :limit => page_limit, :offset => @page_offset*page_limit)
      @temp = Profile.count("id", :conditions  => sql )
      if @temp/page_limit == @page_offset
        @next = 0
      end

    end
  end

  def search
    email = ""
    if params[:email]
      email = params[:email]
    end

    start = ""
    if params[:start_date]
      if params[:start_date][:"s(1i)"] != "" && params[:start_date][:"s(2i)"] != "" && params[:start_date][:"s(3i)"] != ""
        s2 = params[:start_date][:"s(2i)"]
        if s2.length < 2
          s2 = "0" +s2
        end
        s3 = params[:start_date][:"s(3i)"]
        if s3.length < 2
          s3 = "0" +s3
        end
        start = params[:start_date][:"s(1i)"] + "-" +s2 + "-" + s3
      else
        if params[:start_date][:"s(1i)"] != "" || params[:start_date][:"s(2i)"] != "" || params[:start_date][:"s(3i)"] != ""
          if params[:start_date][:"s(1i)"] == ""
            flash["hint_s"] = "!"
          end
          if params[:start_date][:"s(2i)"] == ""
            flash["hint_s"] = "!"
          end
          if params[:start_date][:"s(3i)"] == ""
            flash["hint_s"] = "!"
          end
        end
      end
    end

    eend = ""
    if params[:end_date]
      if params[:end_date][:"e(1i)"] != "" && params[:end_date][:"e(2i)"] != "" && params[:end_date][:"e(3i)"] != ""
        e2 = params[:end_date][:"e(2i)"]
        if e2.length < 2
          e2 = "0" +e2
        end
        e3 = params[:end_date][:"e(3i)"]
        if e3.length < 2
          e3 = "0" +e3
        end
        eend =  params[:end_date][:"e(1i)"] + "-" +e2 +  "-" + e3
      else
        if params[:end_date][:"e(1i)"] != "" || params[:end_date][:"e(2i)"] != "" || params[:end_date][:"e(3i)"] != ""
          if params[:end_date][:"e(1i)"] == ""
            flash["hint_e"] = "!"
          end
          if params[:end_date][:"e(2i)"] == ""
            flash["hint_e"] = "!"
          end
          if params[:end_date][:"e(3i)"] == ""
            flash["hint_e"] = "!"
          end
        end
      end
    end
    redirect_to :action=>"admin", :email =>email, :start =>start, :eend => eend
  end

  def count
    #admin = params[:""]
    @profiles = Profile.find(:all, :order => "user_type DESC", :conditions  => ["created_at like ?", (Time.now).strftime("%Y-%m-%d")+"%"])
    Notifier.deliver_sum_register("", @profiles)
  end

  def profileinfo
    #admin = params[:""]
    profile_id = params[:id]
    @profile = Profile.find_by_id(profile_id)
    #profile_id = @profile.id
    @degree = Degree.find_by_profile_id(profile_id)
    @academics = Academic.find_all_by_profile_id(profile_id)
    @careerinfo = Careerinfo.find_by_profile_id(profile_id)
    @references = ReferenceInfo.find_all_by_profile_id(profile_id)
    @transcript = Transcript.find(:first, :conditions => ["profile_id = ?", profile_id])
    Notifier.deliver_register_info("", @profiles, @degree, @academics, @careerinfo, @references, @transcript)
  end
end

