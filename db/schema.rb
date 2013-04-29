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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 33) do

  create_table "addresses", force: true do |t|
    t.integer "contact_id",                null: false
    t.string  "institution"
    t.string  "department"
    t.string  "street",                    null: false
    t.string  "building_floor_suite_room"
    t.string  "city",                      null: false
    t.string  "state",                     null: false
    t.string  "zip",                       null: false
  end

  add_index "addresses", ["contact_id"], name: "index_addresses_on_contact_id", unique: true

  create_table "admin_assignments", force: true do |t|
    t.integer "user_id",                                       null: false
    t.integer "schedule_id",                                   null: false
    t.boolean "is_vacation_request_subscriber", default: true, null: false
  end

  add_index "admin_assignments", ["schedule_id", "user_id"], name: "index_admin_assignments_on_schedule_id_and_user_id", unique: true

  create_table "allowed_shift_overlaps", force: true do |t|
    t.integer "shift_a_id", null: false
    t.integer "shift_b_id", null: false
  end

  add_index "allowed_shift_overlaps", ["shift_a_id", "shift_b_id"], name: "index_allowed_shift_overlaps_on_shift_a_id_and_shift_b_id", unique: true

  create_table "assignment_labels", force: true do |t|
    t.integer "shift_id", null: false
    t.string  "text",     null: false
  end

  add_index "assignment_labels", ["text", "shift_id"], name: "index_assignment_labels_on_text_and_shift_id", unique: true

  create_table "assignments", force: true do |t|
    t.integer  "shift_id",                             null: false
    t.integer  "person_id",                            null: false
    t.date     "date",                                 null: false
    t.string   "public_note"
    t.string   "private_note"
    t.decimal  "duration",     precision: 2, scale: 1
    t.time     "starts_at"
    t.time     "ends_at"
    t.integer  "label_id"
    t.integer  "editor_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "assignments", ["date", "person_id", "shift_id"], name: "index_assignments_on_date_and_person_id_and_shift_id", unique: true

  create_table "calendar_audits", force: true do |t|
    t.integer  "schedule_id", null: false
    t.date     "date",        null: false
    t.text     "log",         null: false
    t.datetime "updated_at"
  end

  create_table "cme_meeting_requests", force: true do |t|
    t.integer  "requester_id",                  null: false
    t.integer  "schedule_id",                   null: false
    t.integer  "shift_id",                      null: false
    t.string   "status",             limit: 60, null: false
    t.date     "start_date",                    null: false
    t.date     "end_date",                      null: false
    t.date     "meeting_start_date",            null: false
    t.date     "meeting_end_date",              null: false
    t.string   "description",                   null: false
    t.integer  "person_id",                     null: false
    t.text     "events",                        null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contacts", force: true do |t|
    t.string   "type",                 null: false
    t.string   "given_name",           null: false
    t.string   "slug"
    t.string   "other_given_names"
    t.string   "family_name"
    t.string   "photo_uid"
    t.string   "suffix"
    t.string   "titles"
    t.string   "degrees"
    t.date     "employment_starts_on"
    t.date     "employment_ends_on"
    t.string   "email"
    t.string   "phone"
    t.string   "fax"
    t.string   "pager"
    t.string   "alpha_pager"
    t.integer  "address_id"
    t.string   "pubmed_search_term"
    t.string   "netid"
    t.datetime "updated_at"
  end

  create_table "day_notes", force: true do |t|
    t.integer "schedule_id",  null: false
    t.date    "date",         null: false
    t.string  "public_text"
    t.string  "private_text"
  end

  add_index "day_notes", ["schedule_id", "date"], name: "index_day_notes_on_schedule_id_and_date", unique: true

  create_table "deleted_assignments", force: true do |t|
    t.integer  "shift_id",                                    null: false
    t.integer  "person_id",                                   null: false
    t.date     "date"
    t.string   "public_note"
    t.string   "private_note"
    t.decimal  "duration",            precision: 2, scale: 1
    t.time     "starts_at"
    t.time     "ends_at"
    t.integer  "label_id"
    t.integer  "editor_id"
    t.datetime "original_created_at"
    t.datetime "updated_at"
  end

  create_table "events", force: true do |t|
    t.string   "title",       null: false
    t.date     "start_date",  null: false
    t.date     "end_date",    null: false
    t.integer  "schedule_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "funding_sources", force: true do |t|
    t.string   "type"
    t.string   "title"
    t.boolean  "requires_description", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "guest_assignments", force: true do |t|
    t.integer  "shift_id",            null: false
    t.integer  "guest_membership_id", null: false
    t.date     "date",                null: false
    t.integer  "editor_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "guest_assignments", ["guest_membership_id", "shift_id", "date"], name: "guest_shift_date_index", unique: true

  create_table "guest_memberships", force: true do |t|
    t.integer  "schedule_id"
    t.string   "family_name"
    t.string   "given_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "holidays", force: true do |t|
    t.string "title", null: false
    t.date   "date",  null: false
  end

  add_index "holidays", ["date"], name: "index_holidays_on_date"

  create_table "nmff_statuses", force: true do |t|
    t.integer "person_id",                                       null: false
    t.date    "hire_date",                                       null: false
    t.decimal "fte",       precision: 3, scale: 2, default: 1.0, null: false
    t.text    "carryover"
  end

  add_index "nmff_statuses", ["person_id"], name: "index_nmff_statuses_on_person_id", unique: true

  create_table "outside_fund_assignments", force: true do |t|
    t.integer  "meeting_request_id"
    t.string   "meeting_request_type"
    t.string   "description"
    t.integer  "outside_source_fund_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "professional_fund_assignments", force: true do |t|
    t.integer  "meeting_request_id"
    t.string   "meeting_request_type"
    t.string   "description"
    t.integer  "professional_fund_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rotation_assignments", force: true do |t|
    t.integer  "person_id",                            null: false
    t.integer  "rotation_id",                          null: false
    t.date     "starts_on",                            null: false
    t.date     "ends_on",                              null: false
    t.integer  "editor_id"
    t.boolean  "is_deleted",           default: false, null: false
    t.integer  "rotation_schedule_id",                 null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rotation_assignments", ["person_id"], name: "index_rotation_assignments_on_person_id"
  add_index "rotation_assignments", ["rotation_id"], name: "index_rotation_assignments_on_rotation_id"

  create_table "rotation_schedules", force: true do |t|
    t.date     "start_date",                   null: false
    t.boolean  "is_published", default: false, null: false
    t.date     "end_date",                     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rotation_schedules", ["start_date"], name: "index_rotation_schedules_on_start_date", unique: true

  create_table "rotations", force: true do |t|
    t.string "title",                                          null: false
    t.date   "active_on",               default: '1000-01-01', null: false
    t.date   "retired_on",              default: '9999-12-31', null: false
    t.string "display_color", limit: 7, default: "#7A43B6",    null: false
  end

  create_table "schedule_memberships", force: true do |t|
    t.integer "person_id",                                                     null: false
    t.integer "schedule_id",                                                   null: false
    t.decimal "fte",                   precision: 3, scale: 2, default: 1.0,   null: false
    t.string  "initials"
    t.boolean "disable_notifications",                         default: false, null: false
  end

  add_index "schedule_memberships", ["person_id", "schedule_id"], name: "index_schedule_memberships_on_person_id_and_schedule_id", unique: true

  create_table "schedule_rotations", force: true do |t|
    t.integer "schedule_id", null: false
    t.integer "rotation_id", null: false
  end

  add_index "schedule_rotations", ["schedule_id", "rotation_id"], name: "index_schedule_rotations_on_schedule_id_and_rotation_id", unique: true

  create_table "schedule_shifts", force: true do |t|
    t.integer "schedule_id",                         null: false
    t.integer "shift_id",                            null: false
    t.integer "position",            default: 1,     null: false
    t.string  "display_color"
    t.date    "retired_on"
    t.boolean "hide_from_aggregate", default: false, null: false
  end

  create_table "schedules", force: true do |t|
    t.string  "title",                                             null: false
    t.boolean "open_reports",                      default: false, null: false
    t.boolean "allow_switch_offers",               default: false, null: false
    t.boolean "accept_vacation_requests",          default: false, null: false
    t.integer "vacation_request_max_days_advance", default: 0,     null: false
    t.integer "vacation_request_min_days_advance", default: 0,     null: false
    t.boolean "accept_meeting_requests",           default: false, null: false
    t.integer "meeting_request_max_days_advance",  default: 0,     null: false
    t.integer "meeting_request_min_days_advance",  default: 0,     null: false
  end

  add_index "schedules", ["title"], name: "index_schedules_on_title", unique: true

  create_table "shift_groups", force: true do |t|
    t.string  "title",                   null: false
    t.integer "schedule_id",             null: false
    t.text    "shift_ids"
    t.integer "position",    default: 0, null: false
  end

  create_table "shift_totals_reports", force: true do |t|
    t.integer "creator_id",          null: false
    t.date    "start_date",          null: false
    t.date    "end_date"
    t.boolean "end_date_is_today",   null: false
    t.boolean "include_unpublished", null: false
    t.text    "shift_ids",           null: false
    t.text    "groups",              null: false
    t.boolean "hide_empty_shifts",   null: false
    t.integer "schedule_id",         null: false
  end

  create_table "shifts", force: true do |t|
    t.string   "type"
    t.string   "title",                                                    null: false
    t.decimal  "duration",         precision: 2, scale: 1, default: 0.5,   null: false
    t.string   "phone"
    t.time     "starts_at",                                                null: false
    t.time     "ends_at",                                                  null: false
    t.boolean  "show_unpublished",                         default: false, null: false
    t.text     "recurrence"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.boolean  "admin",                default: false
    t.integer  "person_id"
    t.string   "username",                             null: false
    t.string   "password_digest",                      null: false
    t.string   "email",                                null: false
    t.string   "given_name"
    t.string   "family_name"
    t.string   "reset_token"
    t.datetime "last_login_timestamp"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["username"], name: "index_users_on_username", unique: true

  create_table "vacation_requests", force: true do |t|
    t.integer  "requester_id",            null: false
    t.integer  "schedule_id",             null: false
    t.integer  "shift_id",                null: false
    t.string   "status",       limit: 60, null: false
    t.date     "start_date",              null: false
    t.date     "end_date",                null: false
    t.text     "comments"
    t.integer  "person_id",               null: false
    t.text     "events",                  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "vacation_requests", ["requester_id"], name: "index_vacation_requests_on_requester_id"
  add_index "vacation_requests", ["status"], name: "index_vacation_requests_on_status"

  create_table "weekly_calendars", force: true do |t|
    t.integer  "schedule_id",                  null: false
    t.date     "date",                         null: false
    t.boolean  "is_published", default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "weekly_calendars", ["date", "schedule_id"], name: "index_weekly_calendars_on_date_and_schedule_id", unique: true

  create_table "weekly_shift_duration_rules", force: true do |t|
    t.integer  "schedule_id",                         null: false
    t.decimal  "maximum",     precision: 4, scale: 1
    t.decimal  "minimum",     precision: 4, scale: 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "weekly_shift_duration_rules", ["schedule_id"], name: "index_weekly_shift_duration_rules_on_schedule_id", unique: true

end
