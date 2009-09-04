class CreateAcademics < ActiveRecord::Migration
  def self.up
    create_table :academics do |t|
      t.column :id,                       :int
      t.column :institution,              :string
      t.column :city,                     :string
      t.column :state,                    :string
      t.column :degrees,                  :string
      t.column :attend_date_start,        :string
      t.column :attend_date_end,          :string
      t.column :complete,                 :int
      t.column :in_progress,              :int
      t.column :country,                  :string , :limit =>11
      t.column :profile_id,               :int
      t.column :academic_record,          :string
      t.column :flag,                       :int
      t.timestamps
    end
  end

  def self.down
    drop_table :academics
  end
end
