class CreateEnrollments < ActiveRecord::Migration
  def self.up
    create_table :enrollments do |t|
      t.column :id,                       :int
      t.column :current,                  :int
      t.column :previous,                 :int
      t.column :semester,                 :int
      t.column :year,                     :int
      t.column :plan,                     :int
      t.column :profile_id,                :int
     
      t.timestamps
    end
  end

  def self.down
    drop_table :enrollments
  end
end
