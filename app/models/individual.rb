class Individual < ActiveRecord::Base
  belongs_to :instructor_employment

  validates_presence_of :name

  validates_presence_of :email
  validates_format_of :email,
                      :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/,
                      :message => "Please Enter a Valid Email Address.",
                      :if => Proc.new{ |u| !u.email.blank?}

  validates_presence_of :phone
  validates_numericality_of :phone,
                            :only_integer => true,
                            :message =>"Work Phone is not a number.",
                            :if => Proc.new{ |u| !u.phone.blank?}
end
