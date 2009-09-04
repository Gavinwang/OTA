class CreateSchools < ActiveRecord::Migration
  def self.up
    create_table :schools do |t|
      t.column :id,                       :int
      t.column :school,                   :string
      t.column :school_name,              :string
      t.timestamps
    end
  end

  def self.down
    drop_table :schools
  end
end
