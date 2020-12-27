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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_12_27_134112) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "day_part_meals", force: :cascade do |t|
    t.bigint "day_part_id"
    t.bigint "meal_id"
    t.boolean "eaten", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["day_part_id"], name: "index_day_part_meals_on_day_part_id"
    t.index ["meal_id"], name: "index_day_part_meals_on_meal_id"
  end

  create_table "day_parts", force: :cascade do |t|
    t.string "title"
    t.bigint "day_id"
    t.integer "hour"
    t.integer "minute"
    t.integer "time_margin"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["day_id"], name: "index_day_parts_on_day_id"
  end

  create_table "days", force: :cascade do |t|
    t.string "title"
    t.bigint "patient_id"
    t.date "date"
    t.bigint "template_day_id"
    t.integer "sleep_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["patient_id"], name: "index_days_on_patient_id"
    t.index ["template_day_id"], name: "index_days_on_template_day_id"
  end

  create_table "dieticians_patients_relationships", force: :cascade do |t|
    t.bigint "dietician_id"
    t.bigint "patient_id"
    t.index ["dietician_id"], name: "index_dieticians_patients_relationships_on_dietician_id"
    t.index ["patient_id"], name: "index_dieticians_patients_relationships_on_patient_id"
  end

  create_table "meals", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "calories"
    t.integer "fat"
    t.integer "carbo"
    t.integer "protein"
    t.index ["author_id"], name: "index_meals_on_author_id"
  end

  create_table "meals_products_relationships", force: :cascade do |t|
    t.bigint "meal_id"
    t.bigint "product_id"
    t.decimal "units_amount", precision: 7, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["meal_id"], name: "index_meals_products_relationships_on_meal_id"
    t.index ["product_id"], name: "index_meals_products_relationships_on_product_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "title"
    t.integer "calories"
    t.integer "fat"
    t.integer "carbo"
    t.integer "protein"
    t.text "description"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "unit"
    t.integer "unit_amount"
    t.index ["author_id"], name: "index_products_on_author_id"
  end

  create_table "recipes", force: :cascade do |t|
    t.bigint "meal_id"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_recipes_on_author_id"
    t.index ["meal_id"], name: "index_recipes_on_meal_id"
  end

  create_table "steps", force: :cascade do |t|
    t.bigint "recipe_id"
    t.string "content"
    t.integer "order_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["recipe_id"], name: "index_steps_on_recipe_id"
  end

  create_table "template_day_part_meals", force: :cascade do |t|
    t.bigint "template_day_part_id"
    t.bigint "meal_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["meal_id"], name: "index_template_day_part_meals_on_meal_id"
    t.index ["template_day_part_id"], name: "index_template_day_part_meals_on_template_day_part_id"
  end

  create_table "template_day_parts", force: :cascade do |t|
    t.string "title"
    t.bigint "template_day_id"
    t.integer "hour"
    t.integer "minute"
    t.integer "time_margin"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["template_day_id"], name: "index_template_day_parts_on_template_day_id"
  end

  create_table "template_days", force: :cascade do |t|
    t.bigint "patient_id"
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["patient_id"], name: "index_template_days_on_patient_id"
  end

  create_table "trainings", force: :cascade do |t|
    t.integer "hour"
    t.integer "minute"
    t.integer "time_length"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "patient_id"
    t.date "date"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "type"
    t.string "name"
    t.string "surname"
    t.string "tel"
    t.string "pesel"
    t.string "city"
    t.string "street"
    t.string "post_code"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
