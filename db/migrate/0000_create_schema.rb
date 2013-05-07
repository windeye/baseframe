class CreateSchema < ActiveRecord::Migration
  def self.up
    create_table :aspects do |t|
      t.string :name
      t.integer :user_id
      #后添加的
      t.integer :oreder_id
      #后来加的
      t.bollean :contacts_visible, :default => false, :null => false
      t.timestamps
    end
    add_index :aspects, :user_id
    #同时为contacts_visible添加索引
    add_index :aspects, [:user_id, :contacts_visible]
    
    #像是一个join表，
    create_table :aspect_memberships do |t|
      t.integer :aspect_id
      t.integer :contact_id
      t.timestamps
    end
    add_index :aspect_memberships, :aspect_id
    add_index :aspect_memberships, [:aspect_id, :contact_id], :unique => true
    add_index :aspect_memberships, :contact_id

    create_table :comments do |t|
      t.text :text
      #就是post_id
      t.integer :commentable_id
      #person_id
      t.integer :author_id
      t.string :guid
      t.text :author_signature
      t.text :parent_author_signature
      t.string :commentable_type, :default => 'Post', :null => false, :limit => 60
      t.integer :likes_count, :default => 0, :null => false
      t.timestamps
    end
    add_index :comments, :guid, :unique => true
    add_index :comments, :author_id
    #删除post_id的索引，通过关联去实现
    #add_index :comments, :post_id
    add_index :comments, [:commentable_id, :commentable_type]


    create_table :contacts do |t|
      t.integer :user_id
      t.integer :person_id
      #t.boolean :pending, :default => true
      t.boolean :sharing, :default => false, :null => false
      t.boolean :receiving, :default => false, :null => false
      t.timestamps
    end
    #add_index :contacts, [:user_id, :pending]
    #add_index :contacts, [:person_id, :pending]
    add_index :contacts, [:user_id, :person_id], :unique => true

    #create_table :invitations do |t|
    #t.text :message
    #t.integer :sender_id
    #t.integer :recipient_id
    #t.integer :aspect_id
    #t.timestamps
    #end
    #add_index :invitations, :sender_id

    #当有评论时会发通知，应该不只这一个触发条件,target_id就是post_id
    create_table :notifications do |t|
      t.string :target_type
      t.integer :target_id
      t.integer :recipient_id
      t.boolean :unread, :default => true
      t.string :type, :null => :false
      t.timestamps
      #t.integer :actor_id
      #t.string :action
    end
    add_index :notifications, [:target_type, :target_id]

    #为啥要单独出来？不直接在notifications中添加个person_id
    create_table :notification_actors do |t| 
      t.integer :notification_id
      t.integer :person_id
      t.timestamps
    end 
    add_index :notification_actors, :notification_id
    add_index :notification_actors, [:notification_id, :person_id] , :unique => true
    add_index :notification_actors, :person_id  ## if i am not mistaken we don't need this one because we won't query person.notifications

    create_table :people do |t|
      t.string :guid
      t.text :url
      t.string :diaspora_handle
      t.text :serialized_public_key
      t.integer :owner_id
      t.integer :fetch_status, :default => 0
      t.boolean :closed_account, :default => false
      t.timestamps
    end
    add_index :people, :guid, :unique => true
    add_index :people, :owner_id, :unique => true
    add_index :people, :diaspora_handle, :unique => true

    create_table :posts do |t|
      t.integer :author_id
      t.boolean :public, :default => false
      t.string :diaspora_handle
      t.string :guid
      t.boolean :pending, :default => false
      t.string :type
      t.text :text
      t.integer :status_message_id
      t.text :caption
      t.text :remote_photo_path
      t.string :remote_photo_name
      t.string :random_string
      t.string :processed_image #carrierwave's column
      t.string :unprocessed_image #carrierwave's column
      t.integer :objectId
      t.string :root_guid, :limit => 30
      t.integer :likes_count, :default => 0
      t.integer :comments_count, :default => 0
      t.integer :o_embed_cache_id
      t.integer :reshares_count, :default => 0
      t.datetime :interacted_at
      t.string :frame_name
      t.boolean :favorite, :default => false
      t.timestamps
    end
    add_column(:posts, :object_url, :string)
    add_column(:posts, :image_url, :string)
    add_column(:posts, :image_height, :integer)
    add_column(:posts, :image_width, :integer)
    add_column(:posts, :provider_display_name, :string)
    add_column(:posts, :actor_url, :string)

    add_index :posts, :type
    add_index :posts, :author_id
    add_index :posts, :guid
    add_index :posts, :status_message_id
    add_index :posts, [:status_message_id, :pending]
    add_index :posts, :root_guid
    add_index :posts, [:id, :type, :created_at]

    create_table :post_visibilities do |t|
      t.integer :aspect_id
      t.integer :post_id
      t.timestamps
    end
    add_index :post_visibilities, :aspect_id
    add_index :post_visibilities, :post_id

    create_table :profiles do |t|
      t.string :diaspora_handle
      t.string :first_name, :limit => 127
      t.string :last_name, :limit => 127
      t.string :image_url
      t.string :image_url_small
      t.string :image_url_medium
      t.date :birthday
      t.string :gender
      t.text :bio
      t.boolean :searchable, :default => true
      t.integer :person_id
      t.timestamps
    end
    add_index :profiles, [:first_name, :searchable]
    add_index :profiles, [:last_name, :searchable]
    add_index :profiles, [:first_name, :last_name, :searchable]
    add_index :profiles, :person_id

    create_table :requests do |t|
      t.integer :sender_id
      t.integer :recipient_id
      t.integer :aspect_id
      t.timestamps
    end
    add_index :requests, :sender_id
    add_index :requests, :recipient_id
    add_index :requests, [:sender_id, :recipient_id], :unique => true

    create_table :services do |t|
      t.string :type, :limit => 127
      t.integer :user_id
      t.string :provider
      t.string :uid, :limit => 127
      t.string :access_token
      t.string :access_secret
      t.string :nickname
      t.timestamps
    end
    add_index :services, :user_id

    create_table :users do |t|
      t.string :username
      t.text :serialized_private_key
      t.integer :invites, :default => 0
      t.boolean :getting_started, :default => true
      t.boolean :disable_mail, :default => false
      t.string :language

      t.string :email,              :null => false, :default => ""
      t.string :encrypted_password, :null => false, :default => ""

      t.string   :invitation_token, :limit => 60
      t.datetime :invitation_sent_at

      t.string   :reset_password_token
      t.datetime :remember_created_at
      t.string   :remember_token
      t.integer  :sign_in_count, :default => 0
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      t.timestamps
    end
    add_index :users, :username, :unique => true
    add_index :users, :email, :unique => true
    add_index :users, :invitation_token

    add_foreign_key(:comments, :people, :column => :author_id, :dependent => :delete)
    add_foreign_key(:posts, :people, :column => :author_id, :dependent => :delete)
  end

  def self.down
    raise "irreversable migration!"
  end
end
