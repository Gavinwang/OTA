class Profile < ActiveRecord::Base

  def self.validatesFirst
    validates_presence_of :login_email
    validates_length_of :login_email, :maximum =>100
    validates_format_of :login_email,
                        :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/,
                        :message => "Please Enter a Valid Email Address.",
                        :if => Proc.new{ |u| !u.login_email.blank?}
    validates_uniqueness_of :login_email,
                            :message =>"* Email Address already exists.",
                            :if => Proc.new{ |u| !u.login_email.blank?}

    validates_presence_of :password
  end


  def self.validatessecond
    validates_presence_of :con_name,
                          :message =>"First Name is Required."
    validates_length_of :con_name, :maximum =>100

    validates_presence_of :con_last_name,
                          :message =>"Last Name is Required."
    validates_length_of :con_last_name, :maximum =>100

    validates_presence_of :con_legal_first_name,
                          :message =>"Legal First Name is Required."
    validates_length_of :con_legal_first_name, :maximum =>100


    validates_presence_of :mail_street,
                          :message =>"Street is Required."
    validates_length_of :mail_street, :maximum =>100
    validates_presence_of :mail_city,
                          :message =>"City is Required."
    validates_length_of :mail_city, :maximum =>100
    validates_presence_of :mail_state,
                          :message =>"State is Required."
    validates_length_of :mail_state, :maximum =>100
    validates_presence_of :mail_zip_code,
                          :message =>"Zip Code is Required."
    validates_length_of :mail_zip_code, :maximum =>100


    validates_presence_of :permant_street,
                          :message =>"Street is Required."
    validates_length_of :permant_street, :maximum =>100
    validates_presence_of :permant_state,
                          :message =>"State is Required."
    validates_length_of :permant_state, :maximum =>100
    validates_presence_of :permant_city,
                          :message =>"State is Required."
    validates_length_of :permant_city, :maximum =>100
    validates_presence_of :permant_country,
                          :message =>"Permant Country is Required."
    validates_presence_of :permant_regional_code,
                          :message =>"Regional Code is Required."
    validates_length_of :permant_regional_code, :maximum =>100
  end

  def self.validatesThird
    validates_presence_of :social_security_number,
                          :message =>"Social Security Number is Required."
    validates_format_of :social_security_number,
                        :with => /^\d{3}[-]\d{2}[-]\d{4}$/,
                        :message => "Please Enter a Valid Date of Birth.",
                        :if => Proc.new{ |u| !u.birth_date.blank?}

    validates_format_of :home_phone,
                        :with => /^\d{3}[-]\d{3}[-]\d{4}$/,
                        :if => Proc.new{ |u| !u.home_phone.blank?}

    validates_format_of :mobile_phone,
                        :with => /^\d{3}[-]\d{3}[-]\d{4}$/,
                        :if => Proc.new{ |u| !u.mobile_phone.blank?}

    validates_format_of :work_phone,
                        :with => /^\d{3}[-]\d{3}[-]\d{4}$/,
                        :if => Proc.new{ |u| !u.work_phone.blank?}

    validates_presence_of :birth_date,
                          :message =>"Date of Birth is Required."
    validates_format_of :birth_date,
                        :with => /(((0[1-9]|[12][0-9]|3[01])\/((0[13578]|1[02]))|((0[1-9]|[12][0-9]|30)\/(0[469]|11))|(0[1-9]|[1][0-9]|2[0-8])\/(02))\/([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3}))|(29\/02\/(([0-9]{2})(0[48]|[2468][048]|[13579][26])|((0[48]|[2468][048]|[3579][26])00)))/,
                        :message => "Please Enter a Valid Date of Birth.",
                        :if => Proc.new{ |u| !u.birth_date.blank?}
    validates_presence_of :primary

    validates_presence_of :us_military_veteran,
                          :message =>"U.S. Military Veteran is Required."
  end

  def self.validatesFour

    validates_numericality_of :card_number,
                              :only_integer => true,
                              :message =>"Card Number is not a number.",
                              :if => Proc.new{ |u| !u.social_security_number.blank?}
    validates_length_of :card_number, :maximum =>16

    validates_format_of :us_resident_alien,
                        :with => /^\d{2}\/\d{2}\/\d{4}$/i,
                        :message => "Please Enter a Valid Date.",
                        :if => Proc.new{ |u| !u.us_resident_alien.blank?}
  end

  def self.validatesFive
    validates_presence_of :mail_country

    validates_presence_of :birth_date
    validates_format_of :birth_date,
                        :with => /(((0[1-9]|[12][0-9]|3[01])\/((0[13578]|1[02]))|((0[1-9]|[12][0-9]|30)\/(0[469]|11))|(0[1-9]|[1][0-9]|2[0-8])\/(02))\/([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3}))|(29\/02\/(([0-9]{2})(0[48]|[2468][048]|[13579][26])|((0[48]|[2468][048]|[3579][26])00)))/,
                        :message => "Please Enter a Valid Date of Birth.",
                        :if => Proc.new{ |u| !u.birth_date.blank?}

    validates_presence_of :birth_country
    validates_length_of :birth_country, :maximum =>100

    validates_presence_of :citizenship
    validates_length_of :citizenship, :maximum =>100

    validates_numericality_of :home_phone,
                              :only_integer => true,
                              :if => Proc.new{ |u| !u.home_phone.blank?}
    validates_length_of :home_phone, :maximum =>60

    validates_numericality_of :mobile_phone,
                              :only_integer => true,
                              :if => Proc.new{ |u| !u.mobile_phone.blank?}
    validates_length_of :mobile_phone, :maximum =>60

    validates_numericality_of :work_phone,
                              :only_integer => true,
                              :if => Proc.new{ |u| !u.work_phone.blank?}
    validates_length_of :work_phone, :maximum =>60

    validates_presence_of :primary
  end

  def self.validatesHomePhone
    validates_presence_of :home_phone
  end

  def self.validatesMobilePhone
    validates_presence_of :mobile_phone
  end

  def self.validatesWorkPhone
    validates_presence_of :work_phone
  end
end
