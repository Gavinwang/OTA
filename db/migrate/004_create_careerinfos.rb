class CreateCareerinfos < ActiveRecord::Migration
  def self.up
    create_table :careerinfos do |t|
      t.column :id,                         :int
      t.column :current_employer,           :string
      t.column :street,                     :string
      t.column :city,           			:string
      t.column :state,                      :string       
      t.column :zip_code,             		:string
      t.column :position,  					:string
      t.column :total_year,                 :int
      t.column :teaching_license,           :int
      t.column :teaching_license_type,      :string
      t.column :teaching_license_state,     :string
      t.column :teaching_license_years,     :int
      t.column :reason,                 	:string
      t.column :youth_or_adults,            :string
      t.column :profile_id,                  :int
      t.column :state1,                  :int
      t.column :state2,                  :int
      t.column :state3,                  :int
      t.column :semester,                  :string
      t.column :year,                  :string , :limit =>10 
      t.timestamps
    end
  end

  def self.down
    drop_table :careerinfos
  end
end
