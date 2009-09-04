class InstructorEmployment < ActiveRecord::Base
  has_many :individuals

  def self.validatesFirst
    validates_presence_of :instructor_name

    validates_presence_of :email

    validates_format_of :email,
                        :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/,
                        :message => "Please Enter a Valid Email Address.",
                        :if => Proc.new{ |u| !u.email.blank?}

    validates_presence_of :address
    validates_length_of :address, :maximum =>200

    validates_presence_of :home_phone
    validates_length_of :home_phone, :maximum =>20

    validates_presence_of :work_phone
    validates_length_of :work_phone, :maximum =>20

    validates_length_of :cell_phone, :maximum =>20

    validates_presence_of :current_employer

    validates_presence_of :membership
    validates_length_of :membership, :maximum =>200

    validates_presence_of :teach_areas
    validates_length_of :teach_areas, :maximum =>2000

    validates_presence_of :current_teaching
    validates_length_of :current_teaching, :maximum =>2000

    validates_presence_of :edu_bg
    validates_length_of :edu_bg, :maximum =>2000

    validates_presence_of :honors
    validates_length_of :honors, :maximum =>2000

    validates_presence_of :experience
    validates_length_of :experience, :maximum =>20
    validates_numericality_of :experience,
                              :only_integer => true,
                              :if => Proc.new{ |u| !u.experience.blank?}

    validates_presence_of :convicted_felony

    validates_presence_of :highest_degree

    validates_presence_of :signature

    validates_presence_of :other
  end


  def self.validatesSecond
    validates_presence_of :instructor_name

    validates_presence_of :address
    validates_length_of :address, :maximum =>200

    validates_presence_of :last_four_ss

    validates_presence_of :birth_date
    validates_format_of :birth_date,
                        :with => /(((0[1-9]|[12][0-9]|3[01])\/((0[13578]|1[02]))|((0[1-9]|[12][0-9]|30)\/(0[469]|11))|(0[1-9]|[1][0-9]|2[0-8])\/(02))\/([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3}))|(29\/02\/(([0-9]{2})(0[48]|[2468][048]|[13579][26])|((0[48]|[2468][048]|[3579][26])00)))/,
                        :message => "Please Enter a Valid Date.",
                        :if => Proc.new{ |u| !u.birth_date.blank?}

    validates_presence_of :signature2
  end
end