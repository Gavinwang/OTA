# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 14) do

  create_table "academics", :force => true do |t|
    t.string   "institution"
    t.string   "city"
    t.string   "state"
    t.string   "degrees"
    t.string   "attend_date_start"
    t.string   "attend_date_end"
    t.integer  "complete"
    t.integer  "in_progress"
    t.string   "country",           :limit => 11
    t.integer  "profile_id"
    t.string   "academic_record"
    t.integer  "flag"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "careerinfos", :force => true do |t|
    t.string   "current_employer"
    t.string   "street"
    t.string   "city"
    t.string   "state"
    t.string   "zip_code"
    t.string   "position"
    t.integer  "total_year"
    t.integer  "teaching_license"
    t.string   "teaching_license_type"
    t.string   "teaching_license_state"
    t.integer  "teaching_license_years"
    t.string   "reason"
    t.integer  "youth_or_adults"
    t.integer  "profile_id"
    t.integer  "state1"
    t.integer  "state2"
    t.integer  "state3"
    t.string   "semester"
    t.string   "year"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "countries", :force => true do |t|
    t.string   "country_name"
    t.string   "country_code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "degrees", :force => true do |t|
    t.integer  "profile_id"
    t.integer  "school_id"
    t.integer  "professional_id"
    t.integer  "status"
    t.string   "start_date"
    t.string   "degree"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "enrollments", :force => true do |t|
    t.integer  "current"
    t.integer  "previous"
    t.integer  "semester"
    t.integer  "year"
    t.integer  "plan"
    t.integer  "profile_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "individuals", :force => true do |t|
    t.string   "name"
    t.string   "phone"
    t.string   "email"
    t.integer  "instructor_employment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "instructor_employments", :force => true do |t|
    t.string   "instructor_name"
    t.string   "email"
    t.string   "address"
    t.string   "home_phone"
    t.string   "work_phone"
    t.string   "ss"
    t.string   "current_employer"
    t.string   "membership"
    t.integer  "fall"
    t.integer  "spring"
    t.integer  "summer"
    t.integer  "other"
    t.string   "teach_areas"
    t.string   "current_teaching"
    t.text     "edu_bg"
    t.string   "experience"
    t.string   "honors"
    t.integer  "convicted_felony"
    t.string   "highest_degree"
    t.string   "years_experience"
    t.string   "signature"
    t.string   "signature_date"
    t.string   "last_four_ss",     :limit => 5
    t.string   "birth_date"
    t.string   "todays_date"
    t.string   "signature2"
    t.string   "cell_phone"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "professionals", :force => true do |t|
    t.integer  "school_id"
    t.string   "professional"
    t.integer  "start_date"
    t.float    "price"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "profiles", :force => true do |t|
    t.string   "login_email"
    t.string   "password"
    t.string   "con_name"
    t.string   "con_last_name"
    t.string   "con_legal_first_name"
    t.string   "con_middle_name"
    t.string   "con_prefered_first_name"
    t.string   "con_other_name"
    t.string   "mail_street"
    t.string   "mail_city"
    t.string   "mail_state"
    t.string   "mail_zip_code"
    t.string   "mail_country",            :limit => 11
    t.string   "mail_regional_code"
    t.string   "permant_street"
    t.string   "permant_city"
    t.string   "permant_state"
    t.string   "permant_country",         :limit => 11
    t.string   "permant_regional_code"
    t.string   "home_phone"
    t.string   "mobile_phone"
    t.string   "work_phone"
    t.integer  "primary"
    t.string   "email_primary"
    t.string   "email_secondary"
    t.string   "social_security_number"
    t.string   "birth_date"
    t.integer  "us_military_veteran"
    t.integer  "us_citizen"
    t.string   "us_resident_alien",       :limit => 11
    t.string   "card_date"
    t.string   "card_number"
    t.string   "birth_country"
    t.string   "citizenship"
    t.integer  "visa_type"
    t.string   "visa_other"
    t.string   "visa_date"
    t.integer  "gender"
    t.integer  "marital"
    t.integer  "ethnic"
    t.string   "religious"
    t.integer  "states"
    t.integer  "user_type"
    t.integer  "citizenship_type"
    t.integer  "submit_success"
    t.string   "visa_type_other"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "reference_infos", :force => true do |t|
    t.string   "applicant_last_name"
    t.string   "applicant_first_name"
    t.string   "city"
    t.string   "region"
    t.string   "question1"
    t.string   "question2"
    t.string   "question3"
    t.string   "question4"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "position"
    t.string   "organization"
    t.string   "work_phone"
    t.string   "dmail_address"
    t.datetime "date"
    t.string   "signature"
    t.string   "relation_ship"
    t.integer  "profile_id"
    t.string   "file_real_name"
    t.string   "file_stone_name"
    t.string   "file_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "schools", :force => true do |t|
    t.string   "school"
    t.string   "school_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "transcripts", :force => true do |t|
    t.string   "date"
    t.string   "signature"
    t.string   "last_name"
    t.string   "legal_first_name"
    t.string   "middle_name"
    t.string   "prefer_first_name"
    t.string   "other_name"
    t.string   "permanent_street"
    t.string   "permanent_city"
    t.string   "permanent_state"
    t.string   "permanent_zip_code"
    t.datetime "birth_date"
    t.string   "security_number"
    t.string   "bachelor"
    t.string   "mail_street"
    t.integer  "mail_city"
    t.integer  "mail_state"
    t.string   "mail_zip_code"
    t.datetime "attend_date_star"
    t.datetime "attend_date_end"
    t.integer  "profile_id"
    t.integer  "sign_type"
    t.integer  "complete_bottom"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
