class Notifier < ActionMailer::Base

  def forgot_password(user, tick, sent_at = Time.now)

    passwordurl=smtp_settings[:login_url] + "/newpwd/newpwd?tick=" + tick
    @subject = "Reset Your Password"
    @body = {'user'=>user, 'email_logo' => smtp_settings[:email_logo], 'login_url' =>smtp_settings[:login_url], 'pwd_url' =>passwordurl}
    @recipients = user.login_email
    @from = "admissions@ concordiaonline.net"
    @sent_on = sent_at
    @headers = {}
    @content_type = 'text/html'
  end

  def applicant_profile_create(user, sent_at = Time.now)
    @subject = "Concordia University Profile Created"
    @body ={'user'=>user, 'email_logo' => smtp_settings[:email_logo], 'login_url' => smtp_settings[:login_url]}
    @recipients = user.login_email
    @from = "admissions@ concordiaonline.net"
    @sent_on = sent_at
    @headers = {}
    @content_type = 'text/html'
  end

  def sum_register(admin, user, sent_at = Time.now)
    @subject = "Concordia University Profile Created"
    @body ={'user'=>user, 'email_logo' => smtp_settings[:email_logo], 'login_url' => smtp_settings[:login_url]}
    #test account
    admin = "admissions@ concordiaonline.net"
    @recipients = "admissions@ concordiaonline.net"
    @from = "admissions@ concordiaonline.net"
    @sent_on = sent_at
    @headers = {}
    @content_type = 'text/html'
  end

  def register_info(admin, user, state1, state2, state3, state4, state5, sent_at = Time.now)
    @subject = "Concordia University Profile Created"
    @body ={'profile'=>user, 'degree'=>state1, 'academics'=>state2, 'careerinfo'=>state3, 'references'=>state4, 'transcript'=>state5, 'email_logo' => smtp_settings[:email_logo], 'login_url' => smtp_settings[:login_url]}
    #test account
    admin = "admissions@ concordiaonline.net"
    @recipients = "admissions@ concordiaonline.net"
    @from = "admissions@ concordiaonline.net"
    @sent_on = sent_at
    @headers = {}
    @content_type = 'text/html'
  end

  def applicant_profile_submit(user, sent_at = Time.now)
    @subject = "Concordia University Application Successfully Completed"
    @body ={'user'=>user, 'email_logo' => smtp_settings[:email_logo]}
    @recipients = user.login_email
    @from = "admissions@ concordiaonline.net"
    @sent_on = sent_at
    @headers = {}
    @content_type = 'text/html'
  end

  def applicant_ota(user, sent_at = Time.now)
    @subject = "Confirmation of Your Application for Concordia Online Instructor"
    @body ={'user'=>user, 'email_logo' => smtp_settings[:email_logo]}
    @recipients = user.email
    @from = "admissions@ concordiaonline.net"
    @sent_on = sent_at
    @headers = {}
    @content_type = 'text/html'
  end

  def admin_ota(user, indivduals, sent_at = Time.now)
    @subject = "Application for Concordia Online Instructor"
    @body ={'user'=>user, 'email_logo' => smtp_settings[:email_logo], 'indivduals'=> indivduals ,'url'=> smtp_settings[:login_url]}
    @recipients = "admissions@ concordiaonline.net"
    @from = "admissions@ concordiaonline.net"
    @sent_on = sent_at
    @headers = {}
    @content_type = 'text/html'
  end

  def self.admin_profile_created(touser, degree)
    toaddr=touser.login_email
    email=touser.login_email
    touser.user_type == 0 ? dom = "International" : dom = "Domestic"
    start_date = degree.start_date
    program = degree.degree
    require 'iconv'
    conv = Iconv.new("GBK", "UTF-8")
    temp = conv.iconv(touser.con_name.to_s)
    temp << conv.iconv(nil)
    conv.close
    touser.con_name=temp
    require 'iconv'
    conv = Iconv.new("GBK", "UTF-8")
    temp = conv.iconv(touser.con_last_name.to_s)
    temp << conv.iconv(nil)
    conv.close
    touser.con_last_name=temp
    username=touser.con_name.to_s+" "+touser.con_last_name.to_s

    smtpaddr = smtp_settings[:address] #Constants::BASE_SMTP
    smtpport = smtp_settings[:port]
    fromaddr = smtp_settings[:email_addr] #Constants::BASE_FROMADDR
#    account = smtp_settings[:user_name] #Constants::BASE_ACCOUNT
#    pass = smtp_settings[:password] #Constants::BASE_PASS
    domain = smtp_settings[:domain] #Constants::BASE_DOMAIN
    url = smtp_settings[:login_url]

    require 'net/smtp'
    Net::SMTP.start(smtpaddr, smtpport) {|smtp|
      smtp.ready( "#{fromaddr}", "admissions@concordiaonline.net" ) {|f|
        f.puts "From: <admissions@ concordiaonline.net>"
        f.puts "To: admissions@concordiaonline.net"
        f.puts "Subject: Concordia University Profile Created"
        f.puts "Data To Include:"
        f.puts "- E-mail: #{email}"
        f.puts "- International or Domestic: #{dom}"
        f.puts "- Start Date: #{start_date}"
        f.puts "- Program name: #{program}"
        f.puts
      }
    }

  end

  def self.admin_application_submit(touser, trans)
    toaddr=touser.login_email
    email=touser.login_email
    first_name = touser.con_name
    last_name = touser.con_last_name
    touser.user_type == 0 ? dom = "International" : dom = "Domestic"
    start_date = trans.date
    primary_phone = ""
    if touser.primary == 1
      primary_phone = touser.home_phone
    elsif touser.primary == 2
      primary_phone = touser.mobile_phone
    elsif touser.primary == 3
      primary_phone = touser.work_phone
    end

    require 'iconv'
    conv = Iconv.new("GBK", "UTF-8")
    temp = conv.iconv(touser.con_name.to_s)
    temp << conv.iconv(nil)
    conv.close
    touser.con_name=temp
    require 'iconv'
    conv = Iconv.new("GBK", "UTF-8")
    temp = conv.iconv(touser.con_last_name.to_s)
    temp << conv.iconv(nil)
    conv.close
    touser.con_last_name=temp
    #smtp
    smtpaddr = smtp_settings[:address] #Constants::BASE_SMTP
    smtpport = smtp_settings[:port]
    fromaddr = smtp_settings[:email_addr] #Constants::BASE_FROMADDR
    #   account = smtp_settings[:user_name] #Constants::BASE_ACCOUNT
    #   pass = smtp_settings[:password] #Constants::BASE_PASS
    domain = smtp_settings[:domain] #Constants::BASE_DOMAIN
    url = smtp_settings[:login_url]

    require 'net/smtp'
    Net::SMTP.start(smtpaddr, smtpport) {|smtp|
      smtp.ready( "#{fromaddr}", "admissions@concordiaonline.net" ) {|f|
        f.puts "From: <admissions@ concordiaonline.net>"
        f.puts "To: admissions@concordiaonline.net"
        f.puts "Subject: Concordia University Application Submitted"
        f.puts "Data To Include:"
        f.puts "- First Name: #{first_name}"
        f.puts "- Last  Name: #{last_name}"
        f.puts "- Domestic/International: #{dom}"
        f.puts "- Start Date: #{start_date}"
        f.puts "- E-mail: #{email}"
        f.puts "- Primary Phone Number: #{primary_phone}"
        f.puts
      }
    }

  end

  def self.applicant_instructor_employment_submit(touser)
    toaddr=touser.email
    email=touser.email
    require 'iconv'
    conv = Iconv.new("GBK", "UTF-8")
    temp = conv.iconv(touser.instructor_name.to_s)
    temp << conv.iconv(nil)
    conv.close
    touser.instructor_name=temp
    username=touser.instructor_name.to_s
    #smtp
    smtpaddr = smtp_settings[:address] #Constants::BASE_SMTP
    smtpport = smtp_settings[:port]
    fromaddr = smtp_settings[:email_addr] #Constants::BASE_FROMADDR
#    account = smtp_settings[:user_name] #Constants::BASE_ACCOUNT
#    pass = smtp_settings[:password] #Constants::BASE_PASS
    domain = smtp_settings[:domain] #Constants::BASE_DOMAIN
    url = smtp_settings[:login_url]
    require 'net/smtp'
    Net::SMTP.start(smtpaddr, 25) {|smtp|
      smtp.ready( "#{fromaddr}", "#{toaddr}" ) {|f|
        f.puts "From: <#{fromaddr}>"
        f.puts "To: #{username} <'#{toaddr}'>"
        f.puts "Subject:  Concordia University Application Successfully Completed"
        f.puts "<img src='#{url}/images/hc/logo.png' border='0'/>"
        f.puts "Dear #{touser.instructor_name}"
        f.puts
        f.puts "Congratulations!  You have just successfully completed your Concordia University online application."
        f.puts
        f.puts "If you have submitted the application and need to make a correction, please call us at 1-877-251-4405 between 9 "
        f.puts "am 5 pm  EST, Monday through Friday for assistance."
        f.puts
        f.puts "An Enrollment Specialist will be contacting your shortly to assist you in the next steps of the application process. "
        f.puts
        f.puts "Sincerely,"
        f.puts
        f.puts "Your Enrollment Team"
        f.puts "Concordia University"
        f.puts "1-877-251-4405"
        f.puts "admissions@concordiaonline.net"
      }
    }
  end

  def self.admin_instructor_employment_submit(touser)
    toaddr=touser.email
    email=touser.email
    require 'iconv'
    conv = Iconv.new("GBK", "UTF-8")
    temp = conv.iconv(touser.instructor_name.to_s)
    temp << conv.iconv(nil)
    conv.close
    touser.instructor_name=temp
    username=touser.instructor_name.to_s
    #smtp
    smtpaddr = smtp_settings[:address] #Constants::BASE_SMTP
    smtpport = smtp_settings[:port]
    fromaddr = smtp_settings[:email_addr] #Constants::BASE_FROMADDR
    #   account = smtp_settings[:user_name] #Constants::BASE_ACCOUNT
    #   pass = smtp_settings[:password] #Constants::BASE_PASS
    domain = smtp_settings[:domain] #Constants::BASE_DOMAIN
    url = smtp_settings[:login_url]
    require 'net/smtp'
    Net::SMTP.start(smtpaddr, 25) {|smtp|
      smtp.ready( "#{fromaddr}", "admissions@concordiaonline.net" ) {|f|
        f.puts "From: <admissions@ concordiaonline.net>"
        f.puts "To: admissions@concordiaonline.net"
        f.puts "Subject:  Concordia University Application Successfully Completed"
        f.puts "<img src='#{url}/images/hc/logo.png' border='0'/>"
        f.puts
        f.puts "Dear #{touser.instructor_name}"
        f.puts
        f.puts "Congratulations!  You have just successfully completed your Concordia University online application."
        f.puts
        f.puts "If you have submitted the application and need to make a correction, please call us at 1-877-251-4405 between 9 "
        f.puts "am 5 pm  EST, Monday through Friday for assistance."
        f.puts
        f.puts "An Enrollment Specialist will be contacting your shortly to assist you in the next steps of the application process. "
        f.puts
        f.puts "Sincerely,"
        f.puts
        f.puts "Your Enrollment Team"
        f.puts "Concordia University"
        f.puts "1-877-251-4405"
        f.puts "admissions@concordiaonline.net"
      }
    }
  end


end