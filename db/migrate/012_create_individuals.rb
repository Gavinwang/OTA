class CreateIndividuals < ActiveRecord::Migration
  def self.up
    create_table :individuals do |t|
      t.column :id,                           :int
      t.column :name,                         :string
      t.column :phone,                        :string
      t.column :email,                        :string
      t.column :instructor_employment_id,                :int
      t.timestamps
    end
  end

  def self.down
    drop_table :individuals
  end
end
