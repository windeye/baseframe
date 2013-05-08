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

ActiveRecord::Schema.define(:version => 20130507) do

  create_table "account_deletions", :force => true do |t|
    t.string  "diaspora_handle"
    t.integer "person_id"
  end

  create_table "aspect_memberships", :force => true do |t|
    t.integer  "aspect_id"
    t.integer  "contact_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "aspect_memberships", ["aspect_id", "contact_id"], :name => "index_aspect_memberships_on_aspect_id_and_contact_id", :unique => true
  add_index "aspect_memberships", ["aspect_id"], :name => "index_aspect_memberships_on_aspect_id"
  add_index "aspect_memberships", ["contact_id"], :name => "index_aspect_memberships_on_contact_id"

  create_table "aspect_visibilities", :force => true do |t|
    t.integer  "shareable_id",                       :null => false
    t.integer  "aspect_id",                          :null => false
    t.string   "shareable_type", :default => "Post", :null => false
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

  add_index "aspect_visibilities", ["aspect_id"], :name => "index_aspect_visibilities_on_aspect_id"
  add_index "aspect_visibilities", ["shareable_id", "shareable_type", "aspect_id"], :name => "shareable_and_aspect_id"
  add_index "aspect_visibilities", ["shareable_id", "shareable_type"], :name => "index_aspect_visibilities_on_shareable_id_and_shareable_type"

  create_table "aspects", :force => true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.integer  "oreder_id"
    t.boolean  "contacts_visible", :default => false, :null => false
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
  end

  add_index "aspects", ["user_id", "contacts_visible"], :name => "index_aspects_on_user_id_and_contacts_visible"
  add_index "aspects", ["user_id"], :name => "index_aspects_on_user_id"

  create_table "blocks", :force => true do |t|
    t.integer "user_id"
    t.integer "person_id"
  end

  create_table "comments", :force => true do |t|
    t.text     "text"
    t.integer  "commentable_id"
    t.integer  "author_id"
    t.string   "guid"
    t.text     "author_signature"
    t.text     "parent_author_signature"
    t.string   "commentable_type",        :limit => 60, :default => "Post", :null => false
    t.integer  "likes_count",                           :default => 0,      :null => false
    t.datetime "created_at",                                                :null => false
    t.datetime "updated_at",                                                :null => false
  end

  add_index "comments", ["author_id"], :name => "index_comments_on_author_id"
  add_index "comments", ["commentable_id", "commentable_type"], :name => "index_comments_on_commentable_id_and_commentable_type"
  add_index "comments", ["guid"], :name => "index_comments_on_guid", :unique => true

  create_table "contacts", :force => true do |t|
    t.integer  "user_id"
    t.integer  "person_id"
    t.boolean  "sharing",    :default => false, :null => false
    t.boolean  "receiving",  :default => false, :null => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  add_index "contacts", ["person_id"], :name => "index_contacts_on_person_id"
  add_index "contacts", ["user_id", "person_id"], :name => "index_contacts_on_user_id_and_person_id", :unique => true

  create_table "likes", :force => true do |t|
    t.boolean  "positive",                              :default => true
    t.integer  "target_id"
    t.integer  "author_id"
    t.string   "guid"
    t.text     "author_signature"
    t.text     "parent_author_signature"
    t.string   "target_type",             :limit => 60,                   :null => false
    t.datetime "created_at",                                              :null => false
    t.datetime "updated_at",                                              :null => false
  end

  add_index "likes", ["author_id"], :name => "index_likes_on_author_id"
  add_index "likes", ["guid"], :name => "index_likes_on_guid", :unique => true
  add_index "likes", ["target_id", "author_id", "target_type"], :name => "index_likes_on_target_id_and_author_id_and_target_type", :unique => true
  add_index "likes", ["target_id"], :name => "index_likes_on_target_id"

  create_table "mentions", :force => true do |t|
    t.integer "post_id",   :null => false
    t.integer "person_id", :null => false
  end

  add_index "mentions", ["person_id", "post_id"], :name => "index_mentions_on_person_id_and_post_id", :unique => true
  add_index "mentions", ["person_id"], :name => "index_mentions_on_person_id"
  add_index "mentions", ["post_id"], :name => "index_mentions_on_post_id"

  create_table "notification_actors", :force => true do |t|
    t.integer  "notification_id"
    t.integer  "person_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "notification_actors", ["notification_id", "person_id"], :name => "index_notification_actors_on_notification_id_and_person_id", :unique => true
  add_index "notification_actors", ["notification_id"], :name => "index_notification_actors_on_notification_id"
  add_index "notification_actors", ["person_id"], :name => "index_notification_actors_on_person_id"

  create_table "notifications", :force => true do |t|
    t.string   "target_type"
    t.integer  "target_id"
    t.integer  "recipient_id"
    t.boolean  "unread",       :default => true
    t.string   "type"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  add_index "notifications", ["recipient_id"], :name => "index_notifications_on_recipient_id"
  add_index "notifications", ["target_id"], :name => "index_notifications_on_target_id"
  add_index "notifications", ["target_type", "target_id"], :name => "index_notifications_on_target_type_and_target_id"

  create_table "o_embed_caches", :force => true do |t|
    t.string "url",  :limit => 1024, :null => false
    t.text   "data",                 :null => false
  end

  add_index "o_embed_caches", ["url"], :name => "index_o_embed_caches_on_url", :length => {"url"=>333}

  create_table "people", :force => true do |t|
    t.string   "guid"
    t.text     "url"
    t.string   "diaspora_handle"
    t.text     "serialized_public_key"
    t.integer  "owner_id"
    t.integer  "fetch_status",          :default => 0
    t.boolean  "closed_account",        :default => false
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
  end

  add_index "people", ["diaspora_handle"], :name => "index_people_on_diaspora_handle", :unique => true
  add_index "people", ["guid"], :name => "index_people_on_guid", :unique => true
  add_index "people", ["owner_id"], :name => "index_people_on_owner_id", :unique => true

  create_table "pods", :force => true do |t|
    t.string   "host"
    t.boolean  "ssl"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "posts", :force => true do |t|
    t.integer  "author_id"
    t.boolean  "public",                              :default => false
    t.string   "diaspora_handle"
    t.string   "guid"
    t.boolean  "pending",                             :default => false
    t.string   "type",                  :limit => 40
    t.text     "text"
    t.integer  "status_message_id"
    t.text     "remote_photo_path"
    t.string   "remote_photo_name"
    t.string   "random_string"
    t.string   "processed_image"
    t.string   "unprocessed_image"
    t.string   "objectId"
    t.string   "root_guid",             :limit => 30
    t.integer  "likes_count",                         :default => 0
    t.integer  "comments_count",                      :default => 0
    t.integer  "o_embed_cache_id"
    t.integer  "reshares_count",                      :default => 0
    t.datetime "interacted_at"
    t.string   "frame_name"
    t.boolean  "favorite",                            :default => false
    t.datetime "created_at",                                             :null => false
    t.datetime "updated_at",                                             :null => false
    t.string   "object_url"
    t.string   "image_url"
    t.integer  "image_height"
    t.integer  "image_width"
    t.string   "provider_display_name"
    t.string   "actor_url"
  end

  add_index "posts", ["author_id", "root_guid"], :name => "index_posts_on_author_id_and_root_guid", :unique => true
  add_index "posts", ["author_id"], :name => "index_posts_on_author_id"
  add_index "posts", ["guid"], :name => "index_posts_on_guid", :unique => true
  add_index "posts", ["id", "type", "created_at"], :name => "index_posts_on_id_and_type_and_created_at"
  add_index "posts", ["root_guid"], :name => "index_posts_on_root_guid"
  add_index "posts", ["status_message_id", "pending"], :name => "index_posts_on_status_message_id_and_pending"
  add_index "posts", ["status_message_id"], :name => "index_posts_on_status_message_id"
  add_index "posts", ["type", "pending", "id"], :name => "index_posts_on_type_and_pending_and_id"

  create_table "profiles", :force => true do |t|
    t.string   "diaspora_handle"
    t.string   "first_name",       :limit => 127
    t.string   "last_name",        :limit => 127
    t.string   "full_name",        :limit => 70
    t.string   "image_url"
    t.string   "image_url_small"
    t.string   "image_url_medium"
    t.date     "birthday"
    t.string   "gender"
    t.text     "bio"
    t.boolean  "searchable",                      :default => true
    t.integer  "person_id"
    t.boolean  "nsfw",                            :default => false
    t.string   "location"
    t.datetime "created_at",                                         :null => false
    t.datetime "updated_at",                                         :null => false
  end

  add_index "profiles", ["full_name", "searchable"], :name => "index_profiles_on_full_name_and_searchable"
  add_index "profiles", ["full_name"], :name => "index_profiles_on_full_name"
  add_index "profiles", ["person_id"], :name => "index_profiles_on_person_id", :unique => true

  create_table "roles", :force => true do |t|
    t.integer  "person_id"
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "services", :force => true do |t|
    t.string   "type",          :limit => 127
    t.integer  "user_id"
    t.string   "uid",           :limit => 127
    t.string   "access_token"
    t.string   "access_secret"
    t.string   "nickname"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  add_index "services", ["type", "uid"], :name => "index_services_on_type_and_uid"
  add_index "services", ["user_id"], :name => "index_services_on_user_id"

  create_table "share_visibilities", :force => true do |t|
    t.integer  "shareable_id"
    t.boolean  "hidden",         :default => false,  :null => false
    t.integer  "contact_id",                         :null => false
    t.string   "shareable_type", :default => "Post", :null => false
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

  add_index "share_visibilities", ["contact_id"], :name => "index_share_visibilities_on_contact_id"
  add_index "share_visibilities", ["shareable_id", "shareable_type", "contact_id"], :name => "shareable_and_contact_id"
  add_index "share_visibilities", ["shareable_id", "shareable_type", "hidden", "contact_id"], :name => "shareable_and_hidden_contact_id"
  add_index "share_visibilities", ["shareable_id"], :name => "index_share_visibilities_on_shareable_id"

  create_table "tag_followings", :force => true do |t|
    t.integer  "tag_id",     :null => false
    t.integer  "user_id",    :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "tag_followings", ["tag_id", "user_id"], :name => "index_tag_followings_on_tag_id_and_user_id", :unique => true
  add_index "tag_followings", ["tag_id"], :name => "index_tag_followings_on_tag_id"
  add_index "tag_followings", ["user_id"], :name => "index_tag_followings_on_user_id"

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type", :limit => 127
    t.integer  "tagger_id"
    t.string   "tagger_type",   :limit => 127
    t.string   "context",       :limit => 127
    t.datetime "created_at"
  end

  add_index "taggings", ["created_at"], :name => "index_taggings_on_created_at"
  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_context"
  add_index "taggings", ["taggable_id", "taggable_type", "tag_id"], :name => "index_taggings_uniquely", :unique => true

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  add_index "tags", ["name"], :name => "index_tags_on_name", :unique => true

  create_table "user_preferences", :force => true do |t|
    t.string   "email_type"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "username"
    t.text     "serialized_private_key"
    t.boolean  "getting_started",                                  :default => true
    t.boolean  "disable_mail",                                     :default => false
    t.string   "language"
    t.string   "email",                                            :default => "",    :null => false
    t.string   "encrypted_password",                               :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                                    :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "unconfirmed_email"
    t.string   "confirm_email_token",                :limit => 30
    t.datetime "locked_at"
    t.boolean  "auto_follow_back",                                 :default => false
    t.integer  "auto_follow_back_aspect_id"
    t.string   "authentication_token",               :limit => 30
    t.text     "hidden_shareables"
    t.boolean  "show_community_spotlight_in_stream",               :default => true,  :null => false
    t.datetime "created_at",                                                          :null => false
    t.datetime "updated_at",                                                          :null => false
  end

  add_index "users", ["authentication_token"], :name => "index_users_on_authentication_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["username"], :name => "index_users_on_username", :unique => true

end
