class CreateProfessionals < ActiveRecord::Migration
  def self.up
    create_table :professionals do |t|
      t.column :id,                       :int
      t.column :school_id,                 :int
      t.column :professional,             :string
      t.column :start_date,           			:int
      t.column :price,                    :double  
     
      t.timestamps
    end
  end

  def self.down
    drop_table :professionals
  end
end
