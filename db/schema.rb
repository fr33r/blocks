# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_01_08_064130) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "anchor_values", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "row_id"
    t.uuid "anchor_id"
    t.jsonb "data", null: false
    t.string "data_hash", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["anchor_id"], name: "index_anchor_values_on_anchor_id"
    t.index ["row_id"], name: "index_anchor_values_on_row_id"
  end

  create_table "anchors", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "description"
    t.uuid "file_format_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["file_format_id"], name: "index_anchors_on_file_format_id"
  end

  create_table "anchors_columns", id: false, force: :cascade do |t|
    t.uuid "anchor_id", null: false
    t.uuid "column_id", null: false
  end

  create_table "columns", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "description"
    t.string "data_type", null: false
    t.boolean "required", null: false
    t.uuid "file_format_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["file_format_id", "name"], name: "index_columns_on_file_format_id_and_name"
    t.index ["file_format_id"], name: "index_columns_on_file_format_id"
  end

  create_table "data_files", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "state", null: false
    t.string "filename", null: false
    t.integer "total_row_count", null: false
    t.datetime "processing_started_at"
    t.datetime "processing_ended_at"
    t.uuid "file_format_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["file_format_id"], name: "index_data_files_on_file_format_id"
    t.index ["filename"], name: "index_data_files_on_filename"
  end

  create_table "event_store_events", force: :cascade do |t|
    t.uuid "event_id", null: false
    t.string "event_type", null: false
    t.binary "metadata"
    t.binary "data", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "valid_at", precision: nil
    t.index ["created_at"], name: "index_event_store_events_on_created_at"
    t.index ["event_id"], name: "index_event_store_events_on_event_id", unique: true
    t.index ["event_type"], name: "index_event_store_events_on_event_type"
    t.index ["valid_at"], name: "index_event_store_events_on_valid_at"
  end

  create_table "event_store_events_in_streams", force: :cascade do |t|
    t.string "stream", null: false
    t.integer "position"
    t.uuid "event_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.index ["created_at"], name: "index_event_store_events_in_streams_on_created_at"
    t.index ["stream", "event_id"], name: "index_event_store_events_in_streams_on_stream_and_event_id", unique: true
    t.index ["stream", "position"], name: "index_event_store_events_in_streams_on_stream_and_position", unique: true
  end

  create_table "file_formats", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "state", null: false
    t.string "name", null: false
    t.uuid "created_by"
    t.uuid "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_file_formats_on_name"
  end

  create_table "pipelines", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "row_errors", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "message", null: false
    t.uuid "rule_id"
    t.uuid "row_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["row_id"], name: "index_row_errors_on_row_id"
    t.index ["rule_id"], name: "index_row_errors_on_rule_id"
  end

  create_table "row_links", force: :cascade do |t|
    t.uuid "source_row_id", null: false
    t.uuid "target_row_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rows", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "state", null: false
    t.integer "row_number", null: false
    t.string "data_hash", null: false
    t.jsonb "data", null: false
    t.uuid "created_by"
    t.uuid "updated_by"
    t.uuid "data_file_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["data_file_id"], name: "index_rows_on_data_file_id"
    t.index ["data_hash"], name: "index_rows_on_data_hash"
  end

  create_table "rules", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "rule_type", null: false
    t.string "state", null: false
    t.string "name", null: false
    t.string "description"
    t.jsonb "condition", null: false
    t.uuid "created_by"
    t.uuid "updated_by"
    t.uuid "pipeline_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_rules_on_name"
    t.index ["pipeline_id"], name: "index_rules_on_pipeline_id"
  end

  add_foreign_key "row_links", "rows", column: "source_row_id"
  add_foreign_key "row_links", "rows", column: "target_row_id"
end
