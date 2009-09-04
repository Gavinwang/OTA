class Academic < ActiveRecord::Base

  validates_presence_of :institution,
                        :message =>"Institution is Required."
  validates_length_of :institution, :maximum =>100

  validates_presence_of :city,
                        :message =>"City is Required."
  validates_length_of :city, :maximum =>100

  validates_presence_of :state,
                        :message =>"State is Required."
  validates_length_of :state, :maximum =>100
  
  def self.validatesfirst
    validates_presence_of :academic_record,
                          :message =>"Years Taught is Required."
    validates_length_of :academic_record, :maximum =>100
  end
end
