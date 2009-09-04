class PdfController < ApplicationController
  protect_from_forgery :except => [:createView]

  require "rubygems"
  require "prawn"
  require "prawn/layout"
  
  def createdom
    login_email =params[:user_email] 
    if login_email == nil
      return
    end 
    if login_email != nil
      @profile = Profile.find(:first, :conditions => ["login_email = ?  ", login_email ])
      profile_id= @profile.id 
      login_email = @profile.login_email
      @degree = Degree.find_by_profile_id(profile_id)
      @academics = Academic.find_all_by_profile_id(profile_id)
      @careerinfo = Careerinfo.find_by_profile_id(profile_id)
      @references = ReferenceInfo.find_all_by_profile_id(profile_id)
      @transcript = Transcript.find(:first, :conditions => ["profile_id = ?  and sign_type = 1", profile_id])
    else
      return
    end
    if @profile == nil
      return
    end
    ch=countrys
    @filename= login_email + "_Application_Dom_" + Date.today.to_s + ".pdf"

    Prawn::Document.generate("#{RAILS_ROOT}/public/pdfs/#{@filename}", :Page_layout=> :Portrait, :page_size => 'A4', :left_margin =>30 ) do |pdf|

      ApplicatInt.Header(pdf)

      black = "000000"
      blue = "548DD4"
      paddingX = 0
      paddingY = 280
      paddingW = 240
      paddingX1 = paddingX + paddingW + 15
      paddingVW = 200
      paddingH = 30
      ftitleSize = 13
      fvalueSize = 12
      down = 95

      pdf.move_down down
      pdf.text "ONLINE APPLICATION", :size=>21, :align => :center, :style => :bold
      pdf.move_down 15

      pdf.fill_color blue
      pdf.text "Admission Requirements for M.Ed. in Educational Leadership:", :style => :bold, :size=>16
      pdf.move_down 10

      pdf.fill_color black
      pdf.text_box "Completed Concordia University graduate application form (must be completed online) and $50 application fee",
                   :width =>530, :height => pdf.font.height * 3,
                   :overflow => :ellipses

      pdf.text_box "Proof of degree from an accredited institution via official transcripts (Bachelor's and/or Master's). Concordia University will request transcripts on your behalf",
                   :width =>530, :height => pdf.font.height * 3,
                   :overflow => :ellipses

      pdf.text_box "Two letters of recommendation",
                   :width =>550, :height => pdf.font.height * 2,
                   :overflow => :ellipses

      pdf.text_box "A minimum 2.8 GPA for undergraduate coursework(3.0 GPA for any graduate coursework) is required for admission.",
                   :width =>530, :height => pdf.font.height * 3,
                   :overflow => :ellipses

      pdf.move_down 20

      pdf.fill_color blue
      pdf.text "CONTACT INFORMATION", :style => :bold, :size=>16
      pdf.fill_color black

      pdf.move_down 5
      pdf.stroke_horizontal_rule

      if (@profile != nil)
        paddingY = 320
        pdf.cell [paddingX, paddingY], :width => paddingW, :text => "Name: ", :border_style => :none, :font_size => ftitleSize, :align=>:right
        pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => validateValue(@profile.con_name), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        paddingY = paddingY-paddingH
        pdf.cell [paddingX, paddingY], :text =>"Last Name:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => validateValue(@profile.con_last_name), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        paddingY = paddingY-paddingH
        pdf.cell [paddingX, paddingY], :text =>"Legal First Name:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => validateValue(@profile.con_legal_first_name), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        paddingY = paddingY-paddingH
        pdf.cell [paddingX, paddingY], :text =>"Middle Name:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => validateValue(@profile.con_middle_name), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        paddingY = paddingY-paddingH
        pdf.cell [paddingX, paddingY], :text =>"Preferred First Name:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => validateValue(@profile.con_prefered_first_name), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        paddingY = paddingY-paddingH
        pdf.cell [paddingX, paddingY], :text =>"Other name(s) on Academic Records:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        pdf.cell [paddingX1, paddingY], :width => paddingVW, :text =>validateValue(@profile.con_other_name), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
      end

      pdf.start_new_page

      pdf.move_down down

      pdf.fill_color blue
      pdf.text "Mailing Address:", :style => :bold_italic, :size=>16
      pdf.fill_color black

      if (@profile != nil)
        paddingY = 650
        pdf.cell [paddingX, paddingY], :text => "Street: ", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => validateValue(@profile.mail_street), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        paddingY = paddingY-paddingH
        pdf.cell [paddingX, paddingY], :text =>"City/Provence:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => validateValue(@profile.mail_city), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        paddingY = paddingY-paddingH
        pdf.cell [paddingX, paddingY], :text =>"State/Region:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => validateValue(@profile.mail_state), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        paddingY = paddingY-paddingH
        pdf.cell [paddingX, paddingY], :text =>"Regional Code:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => validateValue(@profile.mail_zip_code), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
      end

      pdf.move_down 30

      pdf.fill_color blue
      pdf.text "Permanent Address:", :style => :bold_italic, :size=>16
      pdf.fill_color black

      if (@profile != nil)
        paddingY = 460
        pdf.cell [paddingX, paddingY], :text => "Street:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        pdf.cell [paddingX1, paddingY], :width => paddingVW, :text =>validateValue(@profile.permant_street), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        paddingY = paddingY-paddingH
        pdf.cell [paddingX, paddingY], :text =>"City/Provence:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        pdf.cell [paddingX1, paddingY], :width => paddingVW, :text =>validateValue(@profile.permant_city), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        paddingY = paddingY-paddingH
        pdf.cell [paddingX, paddingY], :text =>"State/Region:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => validateValue(@profile.permant_state), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        paddingY = paddingY-paddingH
        pdf.cell [paddingX, paddingY], :text =>"Country:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => validateValue(ch[@profile.permant_country]), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        paddingY = paddingY-paddingH
        pdf.cell [paddingX, paddingY], :text =>"Regional Code:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        pdf.cell [paddingX1, paddingY], :width => paddingVW, :text =>validateValue(@profile.permant_regional_code), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
      end

      pdf.move_down 30

      pdf.fill_color blue
      pdf.text "Telephone:	", :style => :bold_italic, :size=>16
      pdf.fill_color black

      if (@profile != nil)
        paddingY = 270
        pdf.cell [paddingX, paddingY], :text => "Home Phone:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        if (@profile.primary == 1)
          pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => validateValue(@profile.home_phone)+"   (Primary)", :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        else
          pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => validateValue(@profile.home_phone), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        end
        paddingY = paddingY-paddingH
        pdf.cell [paddingX, paddingY], :text =>"Cell/Mobile Phone:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        if (@profile.primary == 2)
          pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => validateValue(@profile.mobile_phone)+"   (Primary)", :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        else
          pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => validateValue(@profile.mobile_phone), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        end
        paddingY = paddingY-paddingH
        pdf.cell [paddingX, paddingY], :text =>"Work Phone:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        if (@profile.primary == 3)
          pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => validateValue(@profile.work_phone)+"   (Primary)", :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        else
          pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => validateValue(@profile.work_phone), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        end
      end

      pdf.move_down 20

      pdf.fill_color blue
      pdf.text "Email:	", :style => :bold_italic, :size=>16
      pdf.fill_color black

      if (@profile != nil)
        paddingY = 140
        pdf.cell [paddingX, paddingY], :text => "Primary Email Address:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => validateValue(@profile.email_primary), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        paddingY = paddingY-paddingH
        pdf.cell [paddingX, paddingY], :text => "Secondary Email Address:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => validateValue(@profile.email_secondary), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
      end

      pdf.start_new_page

      pdf.move_down down

      pdf.fill_color blue
      pdf.text "PERSONAL INFORMATION", :style => :bold, :size=>16
      pdf.fill_color black

      pdf.move_down 10

      if (@profile != nil)
        paddingY = 650
        pdf.cell [paddingX, paddingY], :text => "Social Security Number:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => validateValue(@profile.social_security_number), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        paddingY = paddingY-paddingH
        pdf.cell [paddingX, paddingY], :text => "Date of Birth:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => validateValue(@profile.birth_date), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        paddingY = paddingY-paddingH
        pdf.cell [paddingX, paddingY], :text => "U.S. Military Veteran?", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        if (@profile.us_military_veteran == 1)
          pdf.cell [paddingX1, paddingY], :width => paddingVW, :text =>"  Yes", :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        else
          pdf.cell [paddingX1, paddingY], :width => paddingVW, :text =>"  No", :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        end
        paddingY = paddingY-paddingH
        pdf.cell [paddingX, paddingY], :text => "Are you a US citizen?", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        if (@profile.us_citizen==1)
          pdf.cell [paddingX1, paddingY], :width => paddingVW, :text =>"  Yes", :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        else
          pdf.cell [paddingX1, paddingY], :width => paddingVW, :text =>"  No", :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        end
        paddingY = paddingY-paddingH
        pdf.cell [paddingX, paddingY], :text => "Are you a Resident Alien of the U.S.?", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        if (@profile.us_citizen==1 && @profile.us_citizen != "")
          pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => "  Yes", :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
          paddingY = paddingY-paddingH
          pdf.cell [paddingX, paddingY], :text => "Date your Resident Alien card was issued:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
          pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => validateValue(@profile.us_resident_alien), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
          paddingY = paddingY-paddingH
          pdf.cell [paddingX, paddingY], :text => "Card number:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
          pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => validateValue(@profile.card_number), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        else
          pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => "  No", :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
          paddingY = paddingY-paddingH
          pdf.cell [paddingX, paddingY], :text => "Decision Pending:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
          if (@profile.citizenship_type == 0)
            pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => "  Yes", :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
          else
            pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => "  No", :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
          end
        end

      end
      pdf.move_down 10

      pdf.text_box "Resident aliens and immigrants must provide documentation verifying resident or immigrant status - contact your admission counselor for details. If you are neither a citizen nor a resident alien/immigrant,please request and complete the international application for admission.",
                   :width =>530, :height => pdf.font.height * 3,
                   :overflow => :ellipses

      pdf.move_down 30
      pdf.fill_color blue
      pdf.text "ACADEMIC BACKGROUND", :style => :bold, :size=>16
      pdf.fill_color black

      pdf.move_down 5
      pdf.stroke_horizontal_rule
      pdf.move_down 5

#      if !@academics.empty?
        pdf.text_box "List below the university or college where you received your bachelor's or master's degree. If you have not yet completed your bachelor's degree,please indicate your anticipated date of graduation and degree.",
                     :width =>530, :height => pdf.font.height * 3,
                     :overflow => :ellipses
        @academic0 = @academics[0]
        @academic1 = @academics[1]
        @academic2 = @academics[2]
#      end
      if @academic0 == nil
        @academic0 = Academic.new
      end
      if (@academic0 != nil)
        paddingY = 280
        pdf.cell [paddingX, paddingY], :text => "Institution:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => validateValue(@academic0.institution), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        paddingY = paddingY-paddingH
        pdf.cell [paddingX, paddingY], :text => "Degrees/Major:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => validateValue(@academic0.degrees), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        paddingY = paddingY-paddingH
        pdf.cell [paddingX, paddingY], :text => "City, State:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => validateValue(@academic0.city) +  validateValue(@academic0.state), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        paddingY = paddingY-paddingH
        pdf.cell [paddingX, paddingY], :text => "Start Date:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => validateValue(@academic0.attend_date_start), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        paddingY = paddingY-paddingH
        pdf.cell [paddingX, paddingY], :text => "End Date:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => validateValue(@academic0.attend_date_end), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        paddingY = paddingY-paddingH
        pdf.cell [paddingX, paddingY], :text => "Completed:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        if (@academic0.complete == 1)
          pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => "  Yes", :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        else
          pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => "  No", :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        end
        paddingY = paddingY-paddingH
        pdf.cell [paddingX, paddingY], :text => "In Progress:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        if (@academic0.complete == 1)
          pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => "  No", :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        else
          pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => "  Yes", :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        end
      end
      if (@academic1 != nil)
        pdf.start_new_page
        pdf.move_down down
        paddingY = 610
        pdf.cell [paddingX, paddingY], :text => "Institution:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => validateValue(@academic1.institution), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        paddingY = paddingY-paddingH
        pdf.cell [paddingX, paddingY], :text => "Degrees/Major:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => validateValue(@academic1.degrees), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        paddingY = paddingY-paddingH
        pdf.cell [paddingX, paddingY], :text => "City, State:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => validateValue(@academic1.city) +  validateValue(@academic1.state), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        paddingY = paddingY-paddingH
        pdf.cell [paddingX, paddingY], :text => "Start Date:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => validateValue(@academic1.attend_date_start), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        paddingY = paddingY-paddingH
        pdf.cell [paddingX, paddingY], :text => "End Date:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => validateValue(@academic1.attend_date_end), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        paddingY = paddingY-paddingH
        pdf.cell [paddingX, paddingY], :text => "Completed:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        if (@academic1.complete == 1)
          pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => "  Yes", :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        else
          pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => "  No", :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        end
        paddingY = paddingY-paddingH
        pdf.cell [paddingX, paddingY], :text => "In Progress:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        if (@academic1.complete == 1)
          pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => "  No", :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        else
          pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => "  Yes", :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        end
      end
      if (@academic2 != nil)
        paddingY = 320
        pdf.cell [paddingX, paddingY], :text => "Institution:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => validateValue(@academic2.institution), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        paddingY = paddingY-paddingH
        pdf.cell [paddingX, paddingY], :text => "Degrees/Major:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => validateValue(@academic2.degrees), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        paddingY = paddingY-paddingH
        pdf.cell [paddingX, paddingY], :text => "City, State:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => validateValue(@academic2.city) +  validateValue(@academic2.state), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        paddingY = paddingY-paddingH
        pdf.cell [paddingX, paddingY], :text => "Start Date:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => validateValue(@academic2.attend_date_start), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        paddingY = paddingY-paddingH
        pdf.cell [paddingX, paddingY], :text => "End Date:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => validateValue(@academic2.attend_date_end), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        paddingY = paddingY-paddingH
        pdf.cell [paddingX, paddingY], :text => "Completed:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        if (@academic2.complete == 1)
          pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => "  Yes", :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        else
          pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => "  No", :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        end
        paddingY = paddingY-paddingH
        pdf.cell [paddingX, paddingY], :text => "In Progress:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        if (@academic2.complete == 1)
          pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => "  No", :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        else
          pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => "  Yes", :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        end
      end

      pdf.start_new_page

      pdf.move_down down

      pdf.fill_color blue
      pdf.text "TRANSCRIPTS", :style => :bold, :size=>16
      pdf.fill_color black 
      pdf.move_down 10
       
      if (@transcript != nil)
        pdf.text_box "Concordia will request your official transcripts from the school where you received your baccalaureate degree on your behalf. This is available only to US residents for US colleges and Universities.",
                     :width =>530, :height => pdf.font.height * 3,
                     :overflow => :ellipses
        pdf.move_down 10
        if (@transcript.complete_bottom == 1)
          pdf.text "Yes, I plan on having Concordia request my transcript(s) by submitting a Transcript Release Form.", :size=>12, :align => :center
        else
          pdf.text "No, I will request my own transcripts and have them sent to Concordia.", :size=>12, :align => :center
        end
      else
        pdf.text_box "Concordia will request your official transcripts from the school where you received your baccalaureate degree on your behalf. This is available only to US residents for US colleges and Universities.",
                     :width =>530, :height => pdf.font.height * 3,
                     :overflow => :ellipses
        pdf.move_down 10
         
        pdf.text "Yes, I plan on having Concordia request my transcript(s) by submitting a Transcript Release Form.", :size=>12, :align => :left
        pdf.move_down 10 
        pdf.text "No, I will request my own transcripts and have them sent to Concordia.", :size=>12, :align => :left
         
      end


      pdf.move_down 30
      pdf.fill_color blue
      pdf.text "OPTIONAL INFO", :style => :bold, :size=>16
      pdf.move_down 5
      pdf.stroke_horizontal_rule
      pdf.move_down 10
      pdf.fill_color black
      pdf.move_down 10
      if (@profile != nil)
        paddingY = 490
        pdf.cell [paddingX, paddingY], :text => "Gender:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        if @profile.gender == 1
          pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => "  Male", :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        else
          pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => "  Female", :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        end
        paddingY = paddingY-paddingH
        pdf.cell [paddingX, paddingY], :text => "Marital Status:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        if @profile.marital == 1
          pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => "  Married", :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        else
          pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => "  Single", :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        end
        paddingY = paddingY-paddingH
        pdf.cell [paddingX, paddingY], :text => "Ethnic Origin:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        if (@profile.ethnic == 1)
          pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => "  American Indian or Alaskan Native", :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        elsif (@profile.ethnic == 2)
          pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => "  Asian American or Pacific Islander ", :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        elsif (@profile.ethnic == 3)
          pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => "  African American", :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        elsif (@profile.ethnic == 4)
          pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => "  Caucasian", :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        elsif (@profile.ethnic == 5)
          pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => "  Hispanic/Latino ", :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        elsif (@profile.ethnic == 6)
          pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => "  Multi-racial ", :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        elsif (@profile.ethnic == 7)
          pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => "  Other", :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        end
        paddingY = paddingY-paddingH
        pdf.cell [paddingX, paddingY], :text => "Religious Preference:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => validateValue(@profile.religious), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
      end

      pdf.move_down 40

      pdf.fill_color blue
      pdf.text "ENROLLMENT PLANS", :style => :bold, :size=>16
      pdf.fill_color black

      pdf.move_down 5
      pdf.stroke_horizontal_rule
      pdf.move_down 10
      
      if @careerinfo == nil
        @careerinfo = Careerinfo.new
      end
      if (@careerinfo != nil)
        paddingY = 280
        pdf.cell [paddingX, paddingY], :text => "Are you currently enrolled at Concordia University?", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        if @careerinfo.state1 == 0
          pdf.cell [paddingX1, paddingY], :width => paddingVW, :text =>"  Yes", :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        else
          pdf.cell [paddingX1, paddingY], :width => paddingVW, :text =>"  No", :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        end
        paddingY = paddingY - paddingH
        pdf.cell [paddingX, paddingY], :text => "Have you previously applied for graduate admission at Concordia University?", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        if @careerinfo.state2 == 0
          pdf.cell [paddingX1, paddingY], :width => paddingVW, :text =>"  Yes", :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
          if @careerinfo.semester != nil
            paddingY = paddingY - paddingH
            pdf.cell [paddingX, paddingY], :width => paddingVW, :text =>"The Semester:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
            pdf.cell [paddingX1, paddingY], :width => paddingVW, :text =>validateValue( @careerinfo.semester), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
          end
          if @careerinfo.year != nil
            paddingY = paddingY - paddingH
            pdf.cell [paddingX, paddingY], :width => paddingVW, :text =>"The Year:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
            pdf.cell [paddingX1, paddingY], :width => paddingVW, :text =>validateValue( @careerinfo.year), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
          end
        else
          pdf.cell [paddingX1, paddingY], :width => paddingVW, :text =>"  No", :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        end
        paddingY = paddingY - paddingH
        pdf.cell [paddingX, paddingY], :text => "I plan to apply for student loans through Concordia.", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        if @careerinfo.state3==1
          pdf.cell [paddingX1, paddingY], :width => paddingVW, :text =>"  Yes", :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        else
          pdf.cell [paddingX1, paddingY], :width => paddingVW, :text =>"  No", :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        end
      end

      pdf.start_new_page
      pdf.move_down down

      pdf.fill_color blue
      pdf.text "CAREER INFORMATION:", :style => :bold, :size=>16
      pdf.fill_color black

      pdf.move_down 10

      if (@careerinfo != nil)
        paddingY = 650
        pdf.cell [paddingX, paddingY], :text => "Current Employer:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        pdf.cell [paddingX1, paddingY], :width => paddingVW, :text =>validateValue(@careerinfo.current_employer), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        paddingY = paddingY - paddingH
        pdf.cell [paddingX, paddingY], :text => "Mailing Address:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        pdf.cell [paddingX1, paddingY], :width => paddingVW, :text =>validateValue(@careerinfo.street), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        paddingY = paddingY - paddingH
        pdf.cell [paddingX, paddingY], :text => "Position or Title:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        pdf.cell [paddingX1, paddingY], :width => paddingVW, :text =>validateValue(@careerinfo.position), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        paddingY = paddingY - paddingH
        pdf.cell [paddingX, paddingY], :text => "Total Number of Years with Current Employer:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        pdf.cell [paddingX1, paddingY], :width => paddingVW, :text =>validateValue(@careerinfo.total_year.to_s), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        paddingY = paddingY - paddingH
        pdf.cell [paddingX, paddingY], :text => "Do you have a teaching license?", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        if @careerinfo.teaching_license == 0
          pdf.cell [paddingX1, paddingY], :width => paddingVW, :text =>"  Yes", :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        else
          pdf.cell [paddingX1, paddingY], :width => paddingVW, :text =>"  No", :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        end
        paddingY = paddingY - paddingH
        pdf.cell [paddingX, paddingY], :text => "If yes, what type?", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        pdf.cell [paddingX1, paddingY], :width => paddingVW, :text =>validateValue(@careerinfo.teaching_license_type), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        paddingY = paddingY - paddingH
        pdf.cell [paddingX, paddingY], :text => "Describe the reason you are pursuing this degree:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        pdf.cell [paddingX1, paddingY], :width => paddingVW, :text =>validateValue(@careerinfo.reason), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        paddingY = paddingY - paddingH
        pdf.cell [paddingX, paddingY], :text => "List leadership experience with Children, Youth and/or Adults:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        pdf.cell [paddingX1, paddingY], :width => paddingVW, :text =>validateValue(@careerinfo.youth_or_adults), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
      end

      pdf.start_new_page

      pdf.move_down down

      pdf.fill_color blue
      pdf.text "AUTHORIZATION", :style => :bold, :size=>16
      pdf.fill_color black

      if @transcript == nil 
        @transcript = Transcript.new
      end
      if (@transcript != nil)
        pdf.move_down 20
        pdf.text_box "By signing this application, I hereby certify that all the information I have provided is accurate. Furthermore, if I am accepted and subsequently attend Concordia University, I agree to abide by all policies and procedures stated in the Concordia University catalog and student handbook and any subsequent updates or revisions to such policies that are communicated to me during my tenure as a Concordia University student.",
                     :width =>530, :height => pdf.font.height * 5,
                     :overflow => :ellipses
        paddingY = 530
        pdf.cell [paddingX, paddingY], :text => "Date:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => validateValue(@transcript.date), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        paddingY = paddingY - paddingH
        pdf.cell [paddingX, paddingY], :text => "Signature:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => validateValue(@transcript.signature), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        pdf.move_down 40
        pdf.text_box "Concordia University admits students of any religion, race, color, national and ethnic origin, sex, age, sexual orientation, and disability to all the rights, privileges, programs, and activities generally accorded or made available to students at the University. It does not discriminate on the basis of religion, race, color, national and ethnic origin, sex, age, sexual orientation, or disability in administration of its educational policies and programs, admission policies, merit scholarships and loan programs, and athletic or other university-administered programs. Complaints or charges should be pled with the University's Title IX coordinator.",
                     :width =>530, :height => pdf.font.height * 7,
                     :overflow => :ellipses

      end
    end
    
     redirect_to :controller => "/pdfs" , :action => @filename
  end


  def createint
   login_email =params[:user_email] 
    if login_email == nil
      return
    end 
    if login_email != nil
      @profile = Profile.find(:first, :conditions => ["login_email = ?  ", login_email ])
      profile_id= @profile.id 
      login_email = @profile.login_email
      profile_id= @profile.id
      @degree = Degree.find_by_profile_id(profile_id)
      @academics = Academic.find_all_by_profile_id(profile_id)
      @careerinfo = Careerinfo.find_by_profile_id(profile_id)
      @references = ReferenceInfo.find_all_by_profile_id(profile_id)
      @transcript = Transcript.find(:first, :conditions => ["profile_id = ?  and sign_type = 1", profile_id])
    else
      return
    end
    if @profile == nil
      return
    end
    ch=countrys
    @filename= login_email + "_Application_Int_" + Date.today.to_s + ".pdf"
    Prawn::Document.generate("#{RAILS_ROOT}/public/pdfs/#{@filename}", :Page_layout=> :Portrait, :page_size => 'A4', :left_margin =>30 ) do |pdf|

      ApplicatInt.Header(pdf)

      black = "000000"
      blue = "548DD4"
      paddingX = 0
      paddingY = 280
      paddingW = 240
      paddingX1 = paddingX + paddingW + 15
      paddingVW = 200
      paddingH = 30
      ftitleSize = 13
      fvalueSize = 12
      down = 95

      pdf.move_down down
      pdf.text "ONLINE APPLICATION", :size=>21, :align => :center, :style => :bold
      pdf.move_down 15

      pdf.fill_color blue
      pdf.text "Admission Requirements for M.Ed. in Educational Leadership:", :style => :bold, :size=>16
      pdf.move_down 10

      pdf.fill_color black
      pdf.text_box "Completed Concordia University graduate application form (must be completed online) and $50 application fee",
                   :width =>530, :height => pdf.font.height * 3,
                   :overflow => :ellipses

      pdf.text_box "Proof of a bachelor's and/or master's degree that is officially recognized by the Ministry of Education. Transcripts must be evaluated by WES (www.wes.org) at the expense of the student.",
                   :width =>530, :height => pdf.font.height * 3,
                   :overflow => :ellipses

      pdf.text_box "Two letters of recommendation",
                   :width =>550, :height => pdf.font.height * 2,
                   :overflow => :ellipses

      pdf.text_box "A minimum 2.8 GPA for undergraduate coursework(3.0 GPA for any graduate coursework) is required for admission.",
                   :width =>530, :height => pdf.font.height * 3,
                   :overflow => :ellipses

      pdf.text_box "A successful score of 80 or better on the IBT (Internet Based Test of the TOEFL) or A successful score of a 550 or better with a TWE of 5 or better.",
                   :width =>530, :height => pdf.font.height * 3,
                   :overflow => :ellipses

      pdf.text_box "Letter of Financial Guarantee, or attached form signed by bank.",
                   :width =>550, :height => pdf.font.height * 2,
                   :overflow => :ellipses

      pdf.text_box "Current Resume of Educational and Work experience.",
                   :width =>550, :height => pdf.font.height * 2,
                   :overflow => :ellipses

      pdf.move_down 20

      pdf.fill_color blue
      pdf.text "CONTACT INFORMATION", :style => :bold, :size=>16
      pdf.fill_color black

      pdf.move_down 5
      pdf.stroke_horizontal_rule

      if (@profile != nil)
        pdf.cell [paddingX, paddingY], :width => paddingW, :text => "Name: ", :border_style => :none, :font_size => ftitleSize, :align=>:right
        pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => validateValue(@profile.con_name), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        paddingY = paddingY-paddingH
        pdf.cell [paddingX, paddingY], :text =>"Last Name:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => validateValue(@profile.con_last_name), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        paddingY = paddingY - paddingH
        pdf.cell [paddingX, paddingY], :text =>"Legal First Name:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => validateValue(@profile.con_legal_first_name), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        paddingY = paddingY - paddingH
        pdf.cell [paddingX, paddingY], :text =>"Middle Name:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => validateValue(@profile.con_middle_name), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        paddingY = paddingY - paddingH
        pdf.cell [paddingX, paddingY], :text =>"Preferred First Name:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => validateValue(@profile.con_prefered_first_name), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        paddingY = paddingY - paddingH
        pdf.cell [paddingX, paddingY], :text =>"Other name(s) on Academic Records:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        pdf.cell [paddingX1, paddingY], :width => paddingVW, :text =>validateValue(@profile.con_other_name), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
      end

      pdf.start_new_page

      pdf.move_down down

      pdf.fill_color blue
      pdf.text "Mailing Address:", :style => :bold_italic, :size=>16
      pdf.fill_color black

      if (@profile != nil)
        paddingY = 650
        pdf.cell [paddingX, paddingY], :text => "Street: ", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => validateValue(@profile.mail_street), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        paddingY = paddingY - paddingH
        pdf.cell [paddingX, paddingY], :text =>"City/Provence:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => validateValue(@profile.mail_city), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        paddingY = paddingY - paddingH
        pdf.cell [paddingX, paddingY], :text =>"State/Region:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => validateValue(@profile.mail_state), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        paddingY = paddingY - paddingH
        pdf.cell [paddingX, paddingY], :text =>"Country:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => validateValue(ch[@profile.mail_country]), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        paddingY = paddingY - paddingH
        pdf.cell [paddingX, paddingY], :text =>"Regional Code:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => validateValue(@profile.mail_regional_code), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
      end

      pdf.move_down 30

      pdf.fill_color blue
      pdf.text "Permanent Address:", :style => :bold_italic, :size=>16
      pdf.fill_color black

      if (@profile != nil)
        paddingY = 460
        pdf.cell [paddingX, paddingY], :text => "Street:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        pdf.cell [paddingX1, paddingY], :width => paddingVW, :text =>validateValue(@profile.permant_street), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        paddingY = paddingY - paddingH
        pdf.cell [paddingX, paddingY], :text =>"City/Provence:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        pdf.cell [paddingX1, paddingY], :width => paddingVW, :text =>validateValue(@profile.permant_city), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        paddingY = paddingY - paddingH
        pdf.cell [paddingX, paddingY], :text =>"State/Region:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => validateValue(@profile.permant_state), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        paddingY = paddingY - paddingH
        pdf.cell [paddingX, paddingY], :text =>"Country:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => validateValue(ch[@profile.permant_country]), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        paddingY = paddingY - paddingH
        pdf.cell [paddingX, paddingY], :text =>"Regional Code:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        pdf.cell [paddingX1, paddingY], :width => paddingVW, :text =>validateValue(@profile.permant_regional_code), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
      end

      pdf.move_down 30

      pdf.fill_color blue
      pdf.text "Telephone:	", :style => :bold_italic, :size=>16
      pdf.fill_color black

      if (@profile != nil)
        paddingY = 270
        pdf.cell [paddingX, paddingY], :text => "Home Phone:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        if (@profile.primary == 1)
          pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => validateValue(@profile.home_phone)+"   (Primary)", :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        else
          pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => validateValue(@profile.home_phone), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        end
        paddingY = paddingY - paddingH
        pdf.cell [paddingX, paddingY], :text =>"Cell/Mobile Phone:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        if (@profile.primary == 2)
          pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => validateValue(@profile.mobile_phone)+"   (Primary)", :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        else
          pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => validateValue(@profile.mobile_phone), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        end
        paddingY = paddingY - paddingH
        pdf.cell [paddingX, paddingY], :text =>"Work Phone:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        if (@profile.primary == 3)
          pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => validateValue(@profile.work_phone)+"   (Primary)", :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        else
          pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => validateValue(@profile.work_phone), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        end
      end

      pdf.move_down 20

      pdf.fill_color blue
      pdf.text "Email:	", :style => :bold_italic, :size=>16
      pdf.fill_color black

      if (@profile != nil)
        paddingY = 140
        pdf.cell [paddingX, paddingY], :text => "Primary Email Address:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => validateValue(@profile.email_primary), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        paddingY = paddingY - paddingH
        pdf.cell [paddingX, paddingY], :text => "Secondary Email Address:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => validateValue(@profile.email_secondary), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
      end

      pdf.start_new_page

      pdf.move_down down

      pdf.fill_color blue
      pdf.text "PERSONAL INFORMATION", :style => :bold, :size=>16
      pdf.fill_color black

      pdf.move_down 10

      if (@profile != nil)
        paddingY = 650
        pdf.cell [paddingX, paddingY], :text => "Date of Birth:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => validateValue(@profile.birth_date), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        paddingY = paddingY - paddingH
        pdf.cell [paddingX, paddingY], :text => "Country of Birth:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => validateValue(@profile.birth_country), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        paddingY = paddingY - paddingH
        pdf.cell [paddingX, paddingY], :text => "Country of Citizenship:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => validateValue(@profile.citizenship), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        paddingY = paddingY - paddingH
        if (@profile.visa_type !=nil)
          pdf.cell [paddingX, paddingY], :text => "Visa Type:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        end
        if (@profile.visa_type == 1)
          pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => "  F1", :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
          paddingY = paddingY - paddingH
          pdf.cell [paddingX, paddingY], :text => "Card Number:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
          pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => validateValue(@profile.card_number), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
          paddingY = paddingY - paddingH
          pdf.cell [paddingX, paddingY], :text => "Visa Date:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
          pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => validateValue(@profile.visa_date), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        elsif (@profile.visa_type == 2)
          pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => "  F2", :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
          paddingY = paddingY - paddingH
          pdf.cell [paddingX, paddingY], :text => "Card Number:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
          pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => validateValue(@profile.card_number), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
          paddingY = paddingY - paddingH
          pdf.cell [paddingX, paddingY], :text => "Visa Date:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
          pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => validateValue(@profile.visa_date), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        elsif (@profile.visa_type == 3)
          pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => "  J1", :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
          paddingY = paddingY - paddingH
          pdf.cell [paddingX, paddingY], :text => "Card Number:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
          pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => validateValue(@profile.card_number), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
          paddingY = paddingY - paddingH
          pdf.cell [paddingX, paddingY], :text => "Visa Date:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
          pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => validateValue(@profile.visa_date), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        elsif (@profile.visa_type == 4)
          pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => "  J2", :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
          paddingY = paddingY - paddingH
          pdf.cell [paddingX, paddingY], :text => "Card Number:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
          pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => validateValue(@profile.card_number), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
          paddingY = paddingY - paddingH
          pdf.cell [paddingX, paddingY], :text => "Visa Date:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
          pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => validateValue(@profile.visa_date), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        elsif (@profile.visa_type == 5)
          pdf.cell [paddingX1, paddingY], :width => paddingVW, :text =>validateValue(@profile.visa_type_other), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        end
      end

      pdf.move_down 60
      pdf.fill_color blue
      pdf.text "ACADEMIC BACKGROUND", :style => :bold, :size=>16
      pdf.fill_color black 
      
      pdf.move_down 5
      pdf.stroke_horizontal_rule
      pdf.move_down 5

 #     if !@academics.empty?
        pdf.text_box "List below the university or college where you received your bachelor's or master's degree. If you have not yet completed your bachelor's degree,please indicate your anticipated date of graduation and degree.",
                     :width =>530, :height => pdf.font.height * 3,
                     :overflow => :ellipses
        @academic0 = @academics[0]
        @academic1 = @academics[1]
        @academic2 = @academics[2]
 #     end
      if @academic0 == nil 
        @academic0 = Academic.new
      end
      if (@academic0 != nil)
        paddingY = 400
        pdf.cell [paddingX, paddingY], :text => "Institution:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => validateValue(@academic0.institution), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        paddingY = paddingY - paddingH
        pdf.cell [paddingX, paddingY], :text => "City, State ,Country:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => validateValue(@academic0.city) +  validateValue(@academic0.state) + validateValue(ch[@academic0.country]), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        paddingY = paddingY - paddingH
        pdf.cell [paddingX, paddingY], :text => "Degrees/Major:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => validateValue(@academic0.degrees), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        paddingY = paddingY - paddingH
        pdf.cell [paddingX, paddingY], :text => "Start Date:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => validateValue(@academic0.attend_date_start), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        paddingY = paddingY - paddingH
        pdf.cell [paddingX, paddingY], :text => "End Date:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => validateValue(@academic0.attend_date_end), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        paddingY = paddingY - paddingH
        pdf.cell [paddingX, paddingY], :text => "Completed:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        if (@academic0.complete == 1)
          pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => "  Yes", :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        else
          pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => "  No", :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        end
        paddingY = paddingY - paddingH
        pdf.cell [paddingX, paddingY], :text => "In Progress:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        if (@academic0.complete == 1)
          pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => "  No", :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        else
          pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => "  Yes", :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        end
      end
      if (@academic1 != nil)
        pdf.start_new_page
        pdf.move_down down
        paddingY = 610
        pdf.cell [paddingX, paddingY], :text => "Institution:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => validateValue(@academic1.institution), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        paddingY = paddingY - paddingH
        pdf.cell [paddingX, paddingY], :text => "City, State, Country:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => validateValue(@academic1.city) +  validateValue(@academic1.state)+ validateValue(ch[@academic1.country]), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        paddingY = paddingY - paddingH
        pdf.cell [paddingX, paddingY], :text => "Degrees/Major:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => validateValue(@academic1.degrees), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        paddingY = paddingY - paddingH
        pdf.cell [paddingX, paddingY], :text => "Start Date:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => validateValue(@academic1.attend_date_start), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        paddingY = paddingY - paddingH
        pdf.cell [paddingX, paddingY], :text => "End Date:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => validateValue(@academic1.attend_date_end), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        paddingY = paddingY - paddingH
        pdf.cell [paddingX, paddingY], :text => "Completed:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        if (@academic1.complete == 1)
          pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => "  Yes", :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        else
          pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => "  No", :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        end
        paddingY = paddingY - paddingH
        pdf.cell [paddingX, paddingY], :text => "In Progress:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        if (@academic1.complete == 1)
          pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => "  No", :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        else
          pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => "  Yes", :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        end
      end
      if (@academic2 != nil)
        paddingY = 320
        pdf.cell [paddingX, paddingY], :text => "Institution:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => validateValue(@academic2.institution), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        paddingY = paddingY - paddingH
        pdf.cell [paddingX, paddingY], :text => "City, State, Country:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => validateValue(@academic2.city) +  validateValue(@academic2.state)+ validateValue(ch[@academic2.country]), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        paddingY = paddingY - paddingH
        pdf.cell [paddingX, paddingY], :text => "Degrees/Major:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => validateValue(@academic2.degrees), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        paddingY = paddingY - paddingH
        pdf.cell [paddingX, paddingY], :text => "Start Date:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => validateValue(@academic2.attend_date_start), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        paddingY = paddingY - paddingH
        pdf.cell [paddingX, paddingY], :text => "End Date:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => validateValue(@academic2.attend_date_end), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        paddingY = paddingY - paddingH
        pdf.cell [paddingX, paddingY], :text => "Completed:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        if (@academic2.complete == 1)
          pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => "  Yes", :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        else
          pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => "  No", :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        end
        paddingY = paddingY - paddingH
        pdf.cell [paddingX, paddingY], :text => "In Progress:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        if (@academic2.complete == 1)
          pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => "  No", :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        else
          pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => "  Yes", :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        end
      end

      pdf.start_new_page

      pdf.move_down down

      pdf.fill_color blue
      pdf.text "OPTIONAL INFO", :style => :bold, :size=>16
      pdf.fill_color black

      pdf.move_down 10

      if (@profile != nil)
        paddingY = 650
        pdf.cell [paddingX, paddingY], :text => "Gender:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        if @profile.gender==1
          pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => "  Male", :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        else
          pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => "  Female", :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        end
        paddingY = paddingY - paddingH
        pdf.cell [paddingX, paddingY], :text => "Marital Status:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        if @profile.marital==1
          pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => "  Married", :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        else
          pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => "  Single", :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        end
        paddingY = paddingY - paddingH
        pdf.cell [paddingX, paddingY], :text => "Religious Preference:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => validateValue(@profile.religious), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
      end

      pdf.move_down 30

      pdf.fill_color blue
      pdf.text "ENROLLMENT PLANS", :style => :bold, :size=>16
      pdf.fill_color black

      pdf.move_down 5
      pdf.stroke_horizontal_rule
      pdf.move_down 10
      
      if @careerinfo == nil 
        @careerinfo = Careerinfo.new
      end
      if (@careerinfo!=nil)
        paddingY = 500
        pdf.cell [paddingX, paddingY], :text => "Are you currently enrolled at Concordia University?", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        if @careerinfo.state1 == 0
          pdf.cell [paddingX1, paddingY], :width => paddingVW, :text =>"  Yes", :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        else
          pdf.cell [paddingX1, paddingY], :width => paddingVW, :text =>"  No", :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        end
        paddingY = paddingY - paddingH
        pdf.cell [paddingX, paddingY], :text => "Have you previously applied for graduate admission at Concordia University?", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        if @careerinfo.state2 == 0
          pdf.cell [paddingX1, paddingY], :width => paddingVW, :text =>"  Yes", :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
          if @careerinfo.semester != nil
            paddingY = paddingY - paddingH
            pdf.cell [paddingX, paddingY], :width => paddingVW, :text =>"The Semester:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
            pdf.cell [paddingX1, paddingY], :width => paddingVW, :text =>validateValue( @careerinfo.semester), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
          end
          if @careerinfo.year != nil
            paddingY = paddingY - paddingH
            pdf.cell [paddingX, paddingY], :width => paddingVW, :text =>"The Year:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
            pdf.cell [paddingX1, paddingY], :width => paddingVW, :text =>validateValue( @careerinfo.year), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
          end
        else
          pdf.cell [paddingX1, paddingY], :width => paddingVW, :text =>"  No", :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        end
      end

      pdf.move_down 50
      pdf.fill_color blue
      pdf.text "CAREER INFORMATION:", :style => :bold, :size=>16
      pdf.fill_color black

      pdf.move_down 5
      pdf.stroke_horizontal_rule
      pdf.move_down 10

      if @careerinfo == nil 
        @careerinfo = Careerinfo.new
      end
      if (@careerinfo != nil)
        paddingY = 330
        pdf.cell [paddingX, paddingY], :text => "Current Employer:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        pdf.cell [paddingX1, paddingY], :width => paddingVW, :text =>validateValue(@careerinfo.current_employer), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        paddingY = paddingY - paddingH
        pdf.cell [paddingX, paddingY], :text => "Mailing Address:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        pdf.cell [paddingX1, paddingY], :width => paddingVW, :text =>validateValue(@careerinfo.street), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        paddingY = paddingY - paddingH
        pdf.cell [paddingX, paddingY], :text => "Position or Title:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        pdf.cell [paddingX1, paddingY], :width => paddingVW, :text =>validateValue(@careerinfo.position), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        paddingY = paddingY - paddingH
        pdf.cell [paddingX, paddingY], :text => "Total Number of Years with Current Employer:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        pdf.cell [paddingX1, paddingY], :width => paddingVW, :text =>validateValue(@careerinfo.total_year.to_s), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        paddingY = paddingY - paddingH
        pdf.cell [paddingX, paddingY], :text => "Do you have a teaching license?", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        if @careerinfo.teaching_license==0
          pdf.cell [paddingX1, paddingY], :width => paddingVW, :text =>"  Yes", :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        else
          pdf.cell [paddingX1, paddingY], :width => paddingVW, :text =>"  No", :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        end
        paddingY = paddingY - paddingH
        pdf.cell [paddingX, paddingY], :text => "If yes, what type?", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        pdf.cell [paddingX1, paddingY], :width => paddingVW, :text =>validateValue(@careerinfo.teaching_license_type), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        paddingY = paddingY - paddingH
        pdf.cell [paddingX, paddingY], :text => "Describe the reason you are pursuing this degree:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        pdf.cell [paddingX1, paddingY], :width => paddingVW, :text =>validateValue(@careerinfo.reason), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        paddingY = paddingY - paddingH
        pdf.cell [paddingX, paddingY], :text => "List leadership experience with Children, Youth and/or Adults:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        pdf.cell [paddingX1, paddingY], :width => paddingVW, :text =>validateValue(@careerinfo.youth_or_adults), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
      end

      pdf.start_new_page

      pdf.move_down down

      pdf.fill_color blue
      pdf.text "AUTHORIZATION", :style => :bold, :size=>16
      pdf.fill_color black

      if @transcript  == nil 
         @transcript = Transcript.new
      end
      if (@transcript != nil)
        pdf.move_down 20
        pdf.text_box "By signing this application, I hereby certify that all the information I have provided is accurate. Furthermore, if I am accepted and subsequently attend Concordia University, I agree to abide by all policies and procedures stated in the Concordia University catalog and student handbook and any subsequent updates or revisions to such policies that are communicated to me during my tenure as a Concordia University student.",
                     :width =>530, :height => pdf.font.height * 5,
                     :overflow => :ellipses
        paddingY = 530
        pdf.cell [paddingX, paddingY], :text => "Date:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => validateValue(@transcript.date), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        paddingY = paddingY - paddingH
        pdf.cell [paddingX, paddingY], :text => "Signature:", :width => paddingW, :border_style => :none, :font_size => ftitleSize, :align=>:right
        pdf.cell [paddingX1, paddingY], :width => paddingVW, :text => validateValue(@transcript.signature), :font_size => fvalueSize, :vertical_padding=> 1, :border_style=>:bottom_only
        pdf.move_down 40
        pdf.text_box "Concordia University admits students of any religion, race, color, national and ethnic origin, sex, age, sexual orientation, and disability to all the rights, privileges, programs, and activities generally accorded or made available to students at the University. It does not discriminate on the basis of religion, race, color, national and ethnic origin, sex, age, sexual orientation, or disability in administration of its educational policies and programs, admission policies, merit scholarships and loan programs, and athletic or other university-administered programs. Complaints or charges should be pled with the University's Title IX coordinator.",
                     :width =>530, :height => pdf.font.height * 7,
                     :overflow => :ellipses
      end 
    end
    
    redirect_to :controller => "/pdfs" , :action => @filename
    
  end

  def NNV none_null_variable
        return none_null_variable == nil ? "" : none_null_variable
  end

  def createView
    login_email = params[:user_email]
    if login_email == nil
      return 
    end
 
    if login_email != nil
      @profile = Profile.find(:first, :conditions => ["login_email = ?  ", login_email ])
      profile_id= @profile.id
      @degree = Degree.find_by_profile_id(profile_id)
      @academics = Academic.find_all_by_profile_id(profile_id)
      @careerinfo = Careerinfo.find_by_profile_id(profile_id)
      @references = ReferenceInfo.find_all_by_profile_id(profile_id)
      @transcript = Transcript.find(:first, :conditions => ["profile_id = ?  and sign_type = 0", profile_id])
    else
      return
    end
    if @profile == nil
      return
    end 
    @filename= login_email + "_" + Date.today.to_s+".pdf" 
    Prawn::Document.generate("#{RAILS_ROOT}/public/pdfs/#{@filename}",:Page_layout=> :Portrait,:page_size => 'A4',:left_margin =>55 ) do |pdf|
 
      pdf.pad(10) {pdf.text "Concordia University Online Admission Application", :size=>20, :align => :center}
      pdf.move_down(10)

      if @profile != nil
        if @profile.login_email != nil && @profile.login_email != ""
          pdf.pad(5) {pdf.text "Email:" + NNV(@profile.login_email), :size=>11}
        end
      end

      if @degree != nil
        if @degree.degree != nil && @degree.degree != ""
          pdf.pad(5) {pdf.text "Program:" + NNV(@degree.degree), :size=>11}
        end
        if @degree.start_date != nil && @degree.start_date != ""
          pdf.pad(5) {pdf.text "Start Date:" + NNV(@degree.start_date), :size=>11}
        end
      end

      if @profile != nil
        pdf.pad(10) {pdf.text "Personal Information", :size=>20}

        pdf.pad(7) { pdf.text "Contact Information", :size=>16}
        pdf.pad(5) { pdf.text "Name:" + NNV(@profile.con_name), :size=>11}
        pdf.pad(5) { pdf.text "Last Name:" + NNV(@profile.con_last_name), :size=>11}
        pdf.pad(5) { pdf.text "Legal First Name:" + NNV(@profile.con_legal_first_name), :size=>11}
        pdf.pad(5) { pdf.text "Middle Name:" + NNV(@profile.con_middle_name), :size=>11}
        pdf.pad(5) { pdf.text "Preferred First Name:" + NNV(@profile.con_prefered_first_name), :size=>11}
        pdf.pad(5) { pdf.text "Other name(s) on Academic Records:" + NNV(@profile.con_other_name), :size=>11}

        pdf.pad(7) { pdf.text "Mailing Address", :size=>16}
        pdf.pad(5) { pdf.text "Street:" + NNV(@profile.mail_street), :size=>11}
        pdf.pad(5) { pdf.text "City:" + NNV(@profile.mail_city), :size=>11}
        pdf.pad(5) { pdf.text "State:" + NNV(@profile.mail_state), :size=>11}
        pdf.pad(5) { pdf.text "Zip Code:" + NNV(@profile.mail_zip_code), :size=>11}

        pdf.pad(7) { pdf.text "Permanent Address", :size=>16}
        pdf.pad(5) { pdf.text "Street:" + NNV(@profile.permant_street), :size=>11}
        pdf.pad(5) { pdf.text "City/Province:" + NNV(@profile.permant_city), :size=>11}
        pdf.pad(5) { pdf.text "State/Region:" + NNV(@profile.permant_state), :size=>11}
        pdf.pad(5) { pdf.text "Country:" + NNV(@profile.permant_country), :size=>11}
        pdf.pad(5) { pdf.text "Regional Code:" + NNV(@profile.permant_regional_code), :size=>11}

        pdf.pad(7) { pdf.text "Phones", :size=>16}
        hphone = NNV(@profile.home_phone)
        mphone = NNV(@profile.mobile_phone)
        wphone = NNV(@profile.work_phone)
        if (@profile.primary == 1)
          hphone = hphone + "(Primary)"
        end
        if (@profile.primary == 2)
          mphone = mphone + "(Primary)"
        end
        if (@profile.primary == 3)
          wphone = wphone + "(Primary)"
        end
        pdf.pad(5) { pdf.text "Home Phone:" + hphone, :size=>11}
        pdf.pad(5) { pdf.text "Cell/Mobile Phone:" + mphone, :size=>11}
        pdf.pad(5) { pdf.text "Work Phone:" + wphone, :size=>11}

        if @profile.social_security_number != nil || @profile.birth_date != nil || @profile.us_military_veteran != nil || @profile.us_citizen != nil
          pdf.pad(7) { pdf.text "Personal Information", :size=>16}
          if  @profile!=nil && @profile.user_type ==1
            pdf.pad(5) { pdf.text "Social Security Number:" + NNV(@profile.social_security_number), :size=>11}
            pdf.pad(5) { pdf.text "Date of Birth:" + NNV(@profile.birth_date), :size=>11}
            if @profile.us_military_veteran==1?
                    pdf.pad(5) { pdf.text "U.S. Military Veteran?:"+"Yes", :size=>11}:pdf.pad(5) { pdf.text "U.S. Military Veteran?:"+"No", :size=>11}
            end

            if @profile.citizenship=="us" && @profile.citizenship!=""
              pdf.pad(5) { pdf.text "Are you a US citizen?:" + "Yes", :size=>11}
            else
              pdf.pad(5) { pdf.text "Are you a US citizen?:" + "No", :size=>11}
              if @profile.us_citizen != nil
                if @profile.us_citizen==1 && @profile.us_citizen != ""
                  pdf.pad(5) { pdf.text "Are you a Resident Alien of the U.S.?:" + "Yes", :size=>11}
                else
                  pdf.pad(5) { pdf.text "Are you a Resident Alien of the U.S.?:" + "No", :size=>11}
                end
                if @profile.us_citizen==1 && @profile.us_citizen != ""
                  pdf.pad(5) { pdf.text "Date your Resident Alien card was issued:" + NNV(@profile.us_resident_alien), :size=>11}
                  pdf.pad(5) { pdf.text "Card Number:"+ NNV(@profile.card_number), :size=>11}
                else
                  if @profile.citizenship_type==0 && @profile.citizenship_type != ""
                    pdf.pad(5) { pdf.text "Decision Pending : yes", :size=>11}
                  end
                end
              end
            end
          end

          if  @profile!=nil && @profile.user_type ==0
            if @profile.birth_date != nil && @profile.birth_date != ""
              pdf.pad(5) { pdf.text "Date of Birth:" + NNV(@profile.birth_date), :size=>11}
            end

            if @profile.birth_country != nil && @profile.birth_country != ""
              pdf.pad(5) { pdf.text "Country of Birth:" + NNV(@profile.birth_country), :size=>11}
            end

            if @profile.visa_type != nil && @profile.visa_type != ""
              pdf.pad(5) { pdf.text "Visa Type:", :size=>11}
              if @profile.visa_type==1
                pdf.pad(5) { pdf.text "F1:", :size=>11}
              elsif @profile.visa_type==2
                pdf.pad(5) { pdf.text "F2:", :size=>11}
              elsif @profile.visa_type==3
                pdf.pad(5) { pdf.text "J1:", :size=>11}
              elsif @profile.visa_type==4
                pdf.pad(5) { pdf.text "J2:", :size=>11}
              elsif @profile.visa_type==5
                pdf.pad(5) { pdf.text "Other:", :size=>11}
              end
            end

            if @profile.visa_type != nil && @profile.visa_type ==5
              if @profile.card_date != nil && @profile.card_date != ""
                pdf.pad(5) { pdf.text "Card number:" + NNV(@profile.card_number), :size=>11}
              end
              if @profile.card_number != nil && @profile.card_number != ""
                pdf.pad(5) { pdf.text "Visa date:" + NNV(@profile.visa_date), :size=>11}
              end
            end
          end
        end

        if @profile.us_resident_alien==1
          pdf.pad(7) { pdf.text "Residency Information", :size=>16}
          if @profile.us_resident_alien==1
            if @profile.card_date != nil && @profile.card_date != ""
              pdf.pad(5) { pdf.text "Date your Resident Alien card was issued" + NNV(@profile.card_number), :size=>16}
            end
            if @profile.card_number != nil && @profile.card_number != ""
              pdf.pad(5) { pdf.text "Card number" + NNV(@profile.visa_date), :size=>16}
            end
          end
        end

        if @profile.gender != nil && @profile.gender != "" || @profile.marital != nil && @profile.marital != "" || @profile.ethnic != nil && @profile.ethnic != "" || @profile.religious != nil && @profile.religious != ""
          pdf.pad(7) { pdf.text "Optional Information", :size=>16}
          if @profile.gender != nil && @profile.gender != ""
            if @profile.gender==1
              pdf.pad(5) { pdf.text "Gender:Male", :size=>11}
            else
              pdf.pad(5) { pdf.text "Gender:Female", :size=>11}
            end
          end
          if @profile.marital != nil && @profile.marital != ""
            if @profile.marital==1
              pdf.pad(5) { pdf.text "Marital Staus:Married", :size=>11}
            else
              pdf.pad(5) { pdf.text "Marital Staus:Single", :size=>11}
            end
          end
        end

        if @profile.ethnic != nil && @profile.ethnic != ""
          if @profile.ethnic==1
            pdf.pad(5) { pdf.text "Ethnic Origin:American Indian or Alaskan Native", :size=>11}
          elsif @profile.ethnic==2
            pdf.pad(5) { pdf.text "Asian American or Pacific Islander", :size=>11}
          elsif @profile.ethnic==3
            pdf.pad(5) { pdf.text "African American", :size=>11}
          elsif @profile.ethnic==4
            pdf.pad(5) { pdf.text "Caucasian", :size=>11}
          elsif @profile.ethnic==5
            pdf.pad(5) { pdf.text "Hispanic/Latino", :size=>11}
          elsif @profile.ethnic==6
            pdf.pad(5) { pdf.text "Multi-racial", :size=>11}
          elsif @profile.ethnic==7
            pdf.pad(5) { pdf.text "Other", :size=>11}
          end
        end
      end

      if !@academics.empty?
        pdf.pad(10) {pdf.text "Academic Information", :size=>20}

        @academics.each do |academic|
          @academic = academic
          if @academic.institution != nil &&  @academic.institution != ""
            pdf.pad(5) { pdf.text "Institution:" + NNV(@academic.institution), :size=>11}
          end
          if @academic.city != nil &&  @academic.city != ""
            pdf.pad(5) { pdf.text "City:" + NNV(@academic.city), :size=>11}
          end
          if @academic.state != nil &&  @academic.state != ""
            pdf.pad(5) { pdf.text "State:" + NNV(@academic.state), :size=>11}
          end
          if @academic.degrees != nil &&  @academic.degrees != ""
            pdf.pad(5) { pdf.text "Degrees/Major:" + NNV(@academic.degrees), :size=>11}
          end
          if @academic.attend_date_start != nil &&  @academic.attend_date_start != ""  && @academic.attend_date_end != nil
            pdf.pad(5) { pdf.text "Dates Attended:" + NNV(@academic.attend_date_start), :size=>11}
          end
          if @academic.complete != nil &&  @academic.complete != ""
            if @academic.complete==1
              pdf.pad(5) { pdf.text "Completed:Yes", :size=>11}
            else
              pdf.pad(5) { pdf.text "Completed:No", :size=>11}
            end
          end
          if @academic.in_progress != nil &&  @academic.in_progress != ""
            if @academic.in_progress==1
              pdf.pad(5) { pdf.text "In Progress:Yes", :size=>11}
            else
              pdf.pad(5) { pdf.text "In Progress:No", :size=>11}
            end
          end
          if session[:isdom] == false
            if @academic.academic_record != nil &&  @academic.academic_record != ""
              pdf.pad(5) { pdf.text "Name on Academic Record:"+ NNV(@academic.academic_record), :size=>11}
            end
          end
        end

        if @transcript !=nil
          if @transcript.complete_bottom == 1
            pdf.pad(7) {pdf.text "Transcript release", :size=>20}
            if @transcript.date != nil && @transcript.date != ""
              pdf.pad(5) { pdf.text "Date:" + NNV(@transcript.date), :size=>11}
            end
            if @transcript.signature != nil && @transcript.signature != ""
              pdf.pad(5) { pdf.text "Signature:" + NNV(@transcript.signature), :size=>11}
            end
          end
        end
      end

      if @careerinfo!= nil
        pdf.pad(10) {pdf.text "Career Information", :size=>20}
        if @careerinfo.current_employer != nil && @careerinfo.current_employer != "" || @careerinfo.street != nil && @careerinfo.street != "" || @careerinfo.position != nil && @careerinfo.position != "" || @careerinfo.total_year != nil && @careerinfo.total_year != "" || @careerinfo.teaching_license != nil && @careerinfo.teaching_license != "" || @careerinfo.teaching_license_type != nil && @careerinfo.teaching_license_type != "" || @careerinfo.teaching_license_state != nil && @careerinfo.teaching_license_state != "" || @careerinfo.teaching_license_years != nil && @careerinfo.teaching_license_years != "" || @careerinfo.reason != nil && @careerinfo.reason != "" || @careerinfo.youth_or_adults != nil && @careerinfo.youth_or_adults != ""
          if @careerinfo.current_employer != nil && @careerinfo.current_employer != ""
            pdf.pad(5) { pdf.text "Current Employer:" + NNV(@careerinfo.current_employer), :size=>11}
          end
          if @careerinfo.street != nil && @careerinfo.street != ""
            pdf.pad(5) { pdf.text "Mailing Address:" + NNV(@careerinfo.street), :size=>11}
          end
          if @careerinfo.position != nil && @careerinfo.position != ""
            pdf.pad(5) { pdf.text "Position or Title:" + NNV(@careerinfo.position), :size=>11}
          end
          if @careerinfo.total_year != nil && @careerinfo.total_year != ""
            pdf.pad(5) { pdf.text "Total Number of Years with Current Employer:" + NNV(@careerinfo.total_year).to_s, :size=>11}
          end
          if @careerinfo.teaching_license != nil && @careerinfo.teaching_license != ""
            if @careerinfo.teaching_license==0
              pdf.pad(5) { pdf.text "Do you have a teaching license?:Yes", :size=>11}
            else
              pdf.pad(5) { pdf.text "Do you have a teaching license?:No", :size=>11}
            end
          end
          if @careerinfo.teaching_license_type != nil && @careerinfo.teaching_license_type != ""
            pdf.pad(5) { pdf.text "If yes, what type?: " + NNV(@careerinfo.teaching_license_type), :size=>11}
          end
          if @careerinfo.teaching_license_state != nil && @careerinfo.teaching_license_state != ""
            pdf.pad(5) { pdf.text "State:" + NNV(@careerinfo.teaching_license_state), :size=>11}
          end
          if @careerinfo.teaching_license_years != nil && @careerinfo.teaching_license_years != ""
            pdf.pad(5) { pdf.text "Years Taught:" + NNV(@careerinfo.teaching_license_years).to_s, :size=>11}
          end
          if @careerinfo.reason != nil && @careerinfo.reason != ""
            pdf.pad(5) { pdf.text "Describe the reason you are pursuing this degree:" + NNV(@careerinfo.reason), :size=>11}
          end
          if @careerinfo.youth_or_adults != nil && @careerinfo.youth_or_adults != ""
            pdf.pad(5) { pdf.text "List leadership experience with Children, Youth and/or Adults:" + NNV(@careerinfo.youth_or_adults), :size=>11}
          end
        end

        pdf.pad(7) {pdf.text "Enrollment Plans", :size=>16}
        if @careerinfo.state1 != nil && @careerinfo.state1 != ""
          if @careerinfo.state1==0
            pdf.pad(5) { pdf.text "Are you currently enrolled at Concordia University Portland? Yes", :size=>11}
          else
            pdf.pad(5) { pdf.text "Are you currently enrolled at Concordia University Portland? No", :size=>11}  
          end

        end
        if @careerinfo.state2 != nil && @careerinfo.state2 != ""
          if @careerinfo.state2==0
            pdf.pad(5) { pdf.text "Have you previously applied for graduate admission at Concordia University Portland? Yes", :size=>11}
          else
            pdf.pad(5) { pdf.text "Have you previously applied for graduate admission at Concordia University Portland? No", :size=>11}
          end

        end
        if @careerinfo.state3 != nil && @careerinfo.state3 != ""
          if @careerinfo.state3==1
            pdf.pad(5) { pdf.text "I plan to apply for student loans through Concordia Portland:Yes", :size=>11}
          else
            pdf.pad(5) { pdf.text "I plan to apply for student loans through Concordia Portland:No", :size=>11}
          end
        end
        if @careerinfo.state2==0
          if @careerinfo.semester != nil
            pdf.pad(5) { pdf.text "The Semester:" + NNV(@careerinfo.semester), :size=>11}
          end
          if @careerinfo.year != nil
            pdf.pad(5) { pdf.text "The Year:" + NNV(@careerinfo.year), :size=>11}
          end
        end
      end

      if !@references.empty?
        pdf.pad(10) {pdf.text "Uploaded", :size=>20}
        pdf.pad(10) {pdf.text "Your Uploaded Files", :size=>16}

        @references.each do |reference|
          @reference = reference
          if @reference.file_real_name != nil
            pdf.pad(5) { pdf.text "File:" + NNV(@reference.file_real_name), :size=>11}
          end
        end
      end
    end
    
    redirect_to :controller => "/pdfs" , :action => @filename
    
  end 
  private

  def validateValue(content)
    if (content == nil)
      return " "
    else
      return "  " + content
    end
  end

  def countrys
    @country = Country.find(:all)
    countryHash = Hash.new
    @country.each do |country|
      countryHash[country.country_code] = country.country_name
    end
    return countryHash
  end
end
