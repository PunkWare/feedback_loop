# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120429093248) do

  create_table "accesses", :force => true do |t|
    t.integer  "user_id"
    t.integer  "survey_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "accesses", ["survey_id", "user_id"], :name => "index_accesses_on_survey_id_and_user_id", :unique => true

  create_table "answers", :force => true do |t|
    t.integer  "question_id"
    t.integer  "user_id"
    t.integer  "choice"
    t.text     "comment"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "answers", ["question_id", "choice"], :name => "index_answers_on_question_id_and_choice"
  add_index "answers", ["question_id", "user_id"], :name => "index_answers_on_question_id_and_user_id", :unique => true

  create_table "questions", :force => true do |t|
    t.integer  "survey_id"
    t.string   "title"
    t.integer  "number_of_choices", :default => 5
    t.string   "first_choice",      :default => "I strongly disagree"
    t.string   "last_choice",       :default => "I strongly agree"
    t.string   "link"
    t.datetime "created_at",                                           :null => false
    t.datetime "updated_at",                                           :null => false
  end

  add_index "questions", ["survey_id", "created_at"], :name => "index_questions_on_survey_id_and_created_at"

  create_table "surveys", :force => true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.string   "key"
    t.boolean  "available",  :default => false
    t.boolean  "anonymous",  :default => false
    t.boolean  "private",    :default => false
    t.string   "link"
    t.integer  "order"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  add_index "surveys", ["created_at"], :name => "index_surveys_on_created_at"
  add_index "surveys", ["key"], :name => "index_surveys_on_key"
  add_index "surveys", ["user_id", "available", "created_at"], :name => "index_surveys_on_user_id_and_available_and_created_at"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "admin",           :default => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

end
