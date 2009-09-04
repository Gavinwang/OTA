class PdfformatController < ApplicationController
require "rubygems"
require "prawn"
require "prawn/layout"

def index
  filename= params[:file_name]
  if filename==nil
    return
  end  
end

def createInt
  pdf = Cuappint.new('P', 'pt','A4');
  pdf.SetAutoPageBreak(true) 
  pdf.AliasNbPages
  pdf.AddPage('P') 
  pdf.Image("#{RAILS_ROOT}/public/images/p_center.PNG",140,90,290,135) 
  
  pdf.SetFont('Arial','B',21)  
  pdf.Ln(190)
  pdf.MultiCell(235,21,"ONLINE APPLICATION" )
#  pdf.Text(180, 235,"ONLINE APPLICATION")
#  pdf.Ln(10)
#  pdf.SetFont('Arial','B',14)
#  pdf.Text(60, 275,"Admission Requirements for M.Ed. in Educational Leadership:")
#  pdf.SetFont('Arial','',12)
#  pdf.Text(70, 295,"Completed Concordia University graduate application form (must be completed online) and $50 application fee")
#  pdf.SetLineWidth(0.4)
#  pdf.Line(60,280,500,280)
    
    todaytime=Date.today.to_s
    path = "#{RAILS_ROOT}/public/pdfs/int_" + todaytime +".pdf"
    pdf.Output("#{path}")
end


def createDom  

 Prawn::Document.generate("#{RAILS_ROOT}/public/pdfs/background.pdf",:page_layout=> :portrait,:skip_page_creation => true) do
   header margin_box.top_left do 
     image("#{RAILS_ROOT}/public/images/p_header.PNG") 
     text "Here's My Fancy Header", :size => 25, :align => :center 
  end
    
  point = [bounds.right-50, bounds.bottom + 25]
  page_counter = lazy_bounding_box(point, :width => 50) do
    text "Page: #{page_count}"
  end
  
 # 100.times do
#    start_new_page
  #  move_down 153
    text "Some text" * 4
#    page_counter.draw
#  end 
 
  footer [margin_box.left, margin_box.bottom + 25] do
    stroke_horizontal_rule
    text "And here's a sexy footer", :size => 16
  end 
  end 
end



def createView
#    login_email = params[:user_email] 
#    if login_email == nil
#      return
#    end
    login_email ="lizetor@163.com" 
    if login_email != nil
      @profile = Profile.find(:first, :conditions => ["login_email = ?  ", login_email ]) 
      profile_id = 10 
     # profile_id= @profile.id
      @degree = Degree.find_by_profile_id(profile_id)
      @academics = Academic.find_all_by_profile_id(profile_id)
      @careerinfo = Careerinfo.find_by_profile_id(profile_id)
      @references = ReferenceInfo.find_all_by_profile_id(profile_id)
      @transcript = Transcript.find(:first, :conditions => ["profile_id = ?  and sign_type = 0",profile_id])
    else
      return
    end 
   # file_name= login_email+"_"+Date.today.to_s+".pdf"
    file_name= "_"+login_email+".pdf"
    Prawn::Document.generate("#{RAILS_ROOT}/public/pdfs/#{file_name}",:Page_layout=> :Portrait,:page_size => 'A4',:left_margin =>55 ) do |pdf|
    
    
  pdf.header pdf.margin_box.top_left do
    pdf.image("#{RAILS_ROOT}/public/images/p_header.PNG",:height=>35) 
    pdf.stroke_horizontal_rule
  end
                
  pdf.footer [pdf.margin_box.left, pdf.margin_box.bottom + 25] do
    pdf.stroke_horizontal_rule
    pdf.text "Page: #{pdf.page_count} #{Date.today.to_s}", :size => 12  
    
  end
  
    pdf.move_down(70) 
       pdf.pad(10) {pdf.text "Concordia University Online Admission Application", :size=>20, :align => :center}
      pdf.move_down(10)  
      if @profile != nil
        if @profile.login_email != nil && @profile.login_email != ""
          pdf.pad(5) {pdf.text "Email:" + @profile.login_email, :size=>11}
        end
      end

      if @degree != nil
        if @degree.degree != nil && @degree.degree != ""
          pdf.pad(5) {pdf.text "Program:"+ @degree.degree, :size=>11}
        end
        if @degree.start_date != nil && @degree.start_date != ""
          pdf.pad(5) {pdf.text "Start Date:" + @degree.start_date, :size=>11}
        end
      end

      pdf.pad(10) {pdf.text "Personal Information", :size=>20}

      pdf.pad(7) { pdf.text "Contact Information", :size=>16}
      pdf.pad(5) { pdf.text "Name:" + @profile.con_name, :size=>11}
      pdf.pad(5) { pdf.text "Last Name:" + @profile.con_last_name, :size=>11}
      pdf.pad(5) { pdf.text "Legal First Name:" + @profile.con_legal_first_name, :size=>11}
      pdf.pad(5) { pdf.text "Middle Name:" + @profile.con_middle_name, :size=>11}
      pdf.pad(5) { pdf.text "Preferred First Name:"  +@profile.con_prefered_first_name, :size=>11}
      pdf.pad(5) { pdf.text "Other name(s) on Academic Records:"+@profile.con_other_name, :size=>11}

      pdf.pad(7) { pdf.text "Mailing Address", :size=>16}
      pdf.pad(5) { pdf.text "Street:"+@profile.mail_street, :size=>11}
      pdf.pad(5) { pdf.text "City:"+@profile.mail_city, :size=>11}
      pdf.pad(5) { pdf.text "State:"+@profile.mail_state, :size=>11}
      pdf.pad(5) { pdf.text "Zip Code:"+@profile.mail_zip_code, :size=>11}

      pdf.pad(7) { pdf.text "Permanent Address", :size=>16}
      pdf.pad(5) { pdf.text "Street:"+@profile.permant_street, :size=>11}
      pdf.pad(5) { pdf.text "City/Province:"+@profile.permant_city, :size=>11}
      pdf.pad(5) { pdf.text "State/Region:"+@profile.permant_state, :size=>11}
      pdf.pad(5) { pdf.text "Country:"+@profile.permant_country, :size=>11}
      pdf.pad(5) { pdf.text "Regional Code:"+@profile.permant_regional_code, :size=>11}

      pdf.pad(7) { pdf.text "Phones", :size=>16}
      hphone = @profile.home_phone
      mphone = @profile.mobile_phone
      wphone = @profile.work_phone
      if (@profile.primary == 1)
        hphone = hphone + "(Primary)"
      end
      if (@profile.primary == 2)
        mphone = mphone + "(Primary)"
      end
      if (@profile.primary == 3)
        wphone = wphone + "(Primary)"
      end
      pdf.pad(5) { pdf.text "Home Phone:"+hphone, :size=>11}
      pdf.pad(5) { pdf.text "Cell/Mobile Phone:"+mphone, :size=>11}
      pdf.pad(5) { pdf.text "Work Phone:"+wphone, :size=>11}

 
      pdf.pad(7) { pdf.text "Personal Information", :size=>16}
      if  @profile!=nil && @profile.user_type ==1
        pdf.pad(5) { pdf.text "Social Security Number:"+@profile.social_security_number, :size=>11}
        pdf.pad(5) { pdf.text "Date of Birth:"+@profile.birth_date, :size=>11}
        if @profile.us_military_veteran==1?
                pdf.pad(5) { pdf.text "U.S. Military Veteran?:"+"Yes", :size=>11}:pdf.pad(5) { pdf.text "U.S. Military Veteran?:"+"No", :size=>11}
        end

        if @profile.citizenship=="us" && @profile.citizenship!=""
          pdf.pad(5) { pdf.text "Are you a US citizen?:"+"Yes", :size=>11}
        else
          pdf.pad(5) { pdf.text "Are you a US citizen?:" + "No", :size=>11}
          if @profile.us_citizen != nil
            if @profile.us_citizen==1 && @profile.us_citizen != ""
              pdf.pad(5) { pdf.text "Are you a Resident Alien of the U.S.?:"+"Yes", :size=>11}
            else
              pdf.pad(5) { pdf.text "Are you a Resident Alien of the U.S.?:"+"No", :size=>11}
            end
            if @profile.us_citizen==1 && @profile.us_citizen != ""
              pdf.pad(5) { pdf.text "Date your Resident Alien card was issued:" + @profile.us_resident_alien, :size=>11}
              pdf.pad(5) { pdf.text "Card Number:" + @profile.card_number, :size=>11}
            else
              if @profile.citizenship_type==0 && @profile.citizenship_type != ""
                pdf.pad(5) { pdf.text "Decision Pending : yes", :size=>11}
              end
            end
          end
        end
      end

      if  @profile!=nil && @profile.user_type ==0
        
      end


      pdf.pad(7) { pdf.text "Optional Information", :size=>16}
      pdf.pad(5) { pdf.text "Gender:"+@profile.gender.to_s, :size=>11}
      pdf.pad(5) { pdf.text "Marital Staus:"+@profile.marital.to_s, :size=>11}
      pdf.pad(5) { pdf.text "Ethnic Origin:"+@profile.ethnic.to_s, :size=>11}
      pdf.pad(5) { pdf.text "Religious Preference:"+@profile.religious, :size=>11}
     
   #  redirect_to  :action => 'index',:file_name => file_name
    end
  end
  
end