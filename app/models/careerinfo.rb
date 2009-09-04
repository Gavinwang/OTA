class Careerinfo < ActiveRecord::Base

  validates_presence_of :state1,
                        :message => "* Some required information is missing or incomplete. Please check your entries and try again."
  validates_presence_of :state2,
                        :message => "* Some required information is missing or incomplete. Please check your entries and try again."

  validates_length_of :street, :maximum =>2000

  validates_length_of :reason, :maximum =>2000

  validates_length_of :youth_or_adults, :maximum =>2000

  validates_numericality_of :total_year,
                            :only_integer => true,
                            :if => Proc.new{ |u| !u.total_year.blank?}
  validates_numericality_of :teaching_license_years,
                            :only_integer => true,
                            :if => Proc.new{ |u| !u.teaching_license_years.blank?}
  def self.validatesfirst
    validates_presence_of :semester,
                          :message => "* Some required information is missing or incomplete. Please check your entries and try again."
    validates_length_of :semester, :maximum =>100
    
    validates_presence_of :year,
                          :message => "* Some required information is missing or incomplete. Please check your entries and try again."
    validates_length_of :year, :maximum =>4
  end

end
