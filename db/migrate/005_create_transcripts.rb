class CreateTranscripts < ActiveRecord::Migration
  def self.up
    create_table :transcripts do |t|
      t.column :id,                       :int
      t.column :date,                     :string
      t.column :signature,                :string
      t.column :last_name,           	  :string
      t.column :legal_first_name,           :string       
      t.column :middle_name,               :string
      t.column :prefer_first_name,  		  :string
      t.column :other_name,                :string
      t.column :permanent_street,          :string
      t.column :permanent_city,            :string
      t.column :permanent_state,           :string
      t.column :permanent_zip_code,         :string
      t.column :birth_date,                :datetime
      t.column :security_number,           :string
      t.column :bachelor,                 :string
      t.column :mail_street,               :string
      t.column :mail_city,                 :int
      t.column :mail_state,                :int
      t.column :mail_zip_code,              :string
      t.column :attend_date_star,           :datetime
      t.column :attend_date_end,            :datetime
      t.column :profile_id,                :int
      t.column :sign_type,                :int
      t.column :complete_bottom,         :int
      t.timestamps
    end
  end

  def self.down
    drop_table :transcripts
  end
end
