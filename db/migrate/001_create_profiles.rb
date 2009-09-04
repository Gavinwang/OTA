class CreateProfiles < ActiveRecord::Migration
  def self.up
    create_table :profiles do |t|
      t.column :id,                           :int
      t.column :login_email,                  :string
      t.column :password,                     :string
      t.column :con_name,                     :string
      t.column :con_last_name,                :string
      t.column :con_legal_first_name,         :string
      t.column :con_middle_name,              :string       
      t.column :con_prefered_first_name,      :string
      t.column :con_other_name,               :string
      t.column :mail_street,                  :string
      t.column :mail_city,                    :string
      t.column :mail_state,                   :string
      t.column :mail_zip_code,                :string
      t.column :mail_country,                 :string , :limit =>11
      t.column :mail_regional_code,           :string
      t.column :permant_street,               :string
      t.column :permant_city,                 :string  
      t.column :permant_state,                :string
      t.column :permant_country,              :string , :limit =>11
      t.column :permant_regional_code,        :string
      t.column :home_phone,                   :string
      t.column :mobile_phone,                 :string
      t.column :work_phone,                   :string
      t.column :primary,                      :int
      t.column :email_primary,                :string
      t.column :email_secondary,              :string
      t.column :social_security_number,       :string
      t.column :birth_date,                   :string
      t.column :us_military_veteran,          :int
      t.column :us_citizen,                   :int
      t.column :us_resident_alien,            :string , :limit =>11
      t.column :card_date,                    :string , :limit =>21
      t.column :card_number,                  :string
      t.column :birth_country,                :string
      t.column :citizenship,                  :string
      t.column :visa_type,                    :int
      t.column :visa_other,                   :string
      t.column :visa_date,                    :string , :limit =>21
      t.column :gender,                       :int
      t.column :marital,                      :int
      t.column :ethnic,                       :int
      t.column :religious,                    :string
      t.column :states,                       :int
      t.column :user_type,                    :int 
      t.column :citizenship_type,             :int
      t.column :submit_success,               :int
      t.column :visa_type_other,              :string
      t.timestamps
    end
  end

  def self.down
    drop_table :profiles
  end
end
