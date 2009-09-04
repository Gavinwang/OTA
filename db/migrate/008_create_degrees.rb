class CreateDegrees < ActiveRecord::Migration
  def self.up
    create_table :degrees do |t|
      t.column :id,                       :int
      t.column :profile_id,               :int
      t.column :school_id,                :int
      t.column :professional_id,          :int
      t.column :status,                   :int
      t.column :start_date,               :string
      t.column :degree,                   :string

      t.timestamps
    end
  end

  def self.down
    drop_table :degrees
  end
end
