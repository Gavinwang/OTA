class CreateReferenceInfos < ActiveRecord::Migration
  def self.up
    create_table :reference_infos do |t|
      t.column :id,                       		:int
      t.column :applicant_last_name,            :string
      t.column :applicant_first_name,           :string
      t.column :city,           				:string
      t.column :region,                         :string       
      t.column :question1,             			:string
      t.column :question2,  					:string
      t.column :question3,                 		:string
      t.column :question4,                 		:string
      t.column :first_name,                 	:string
      t.column :last_name,                 		:string
      t.column :position,                 		:string
      t.column :organization,                   :string
      t.column :work_phone,                 	:string
      t.column :dmail_address,                  :string
      t.column :date,                 			:datetime
      t.column :signature,                 		:string
      t.column :relation_ship,                  :string
      t.column :profile_id,                 	:int
      t.column :file_real_name,                 :string
      t.column :file_stone_name,                :string
      t.column :file_url,                       :string 
      t.timestamps
    end
  end

  def self.down
    drop_table :reference_infos
  end
end
 