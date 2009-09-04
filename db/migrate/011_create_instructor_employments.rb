class CreateInstructorEmployments < ActiveRecord::Migration
  def self.up
    create_table :instructor_employments do |t|
      t.column :id,                           :int
      t.column :instructor_name,              :string
      t.column :email,                        :string
      t.column :address,                      :string
      t.column :home_phone,                   :string
      t.column :work_phone,                   :string
      t.column :ss,                           :string
      t.column :current_employer,             :string
      t.column :membership,                   :string
      t.column :fall,                         :int
      t.column :spring,                       :int
      t.column :summer,                       :int
      t.column :other,                        :int
      t.column :teach_areas,                  :string
      t.column :current_teaching,             :string
      t.column :edu_bg,                       :text
      t.column :experience,                   :string
      t.column :honors,                       :string
      t.column :convicted_felony,             :int
      t.column :highest_degree,               :string
      t.column :years_experience,             :string
      t.column :signature,                    :string
      t.column :signature_date,               :string
      t.column :last_four_ss,                 :string, :limit =>5
      t.column :birth_date,                   :string
      t.column :todays_date,                  :string
      t.column :signature2,                   :string
      t.column :cell_phone,                   :string
      t.timestamps
    end
  end

  def self.down
    drop_table :instructor_employments
  end
end
