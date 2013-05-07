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

    create_table :blocks do |t|
      t.integer :user_id
      t.integer :person_id
    end

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

    create_table :likes do |t| 
      t.boolean :positive, :default => true
      t.integer :target_id  #post_id
      t.integer :author_id
      t.string :guid
      t.text :author_signature
      t.text :parent_author_signature
      t.string :target_type, :limit => 60, :null => false
      t.timestamps
    end 

    add_index :likes, :guid, :unique => true
    add_index :likes, :author_id
    add_index :likes, :target_id
    add_index :likes, [:target_id, :author_id, :target_type], :unique => true
    #add_foreign_key(:likes, :posts, :dependent => :delete)
    add_foreign_key(:likes, :people, :column =>  :author_id, :dependent => :delete)

    create_table :mentions do |t| 
      t.integer :post_id, :null => false
      t.integer :person_id, :null => false
    end 
    add_index :mentions, :post_id
    add_index :mentions, :person_id
    add_index :mentions, [:person_id, :post_id], :unique => true

    create_table :o_embed_caches do |t| 
      t.string :url, :limit => 1024, :null => false, :unique => true
      t.text :data, :null => false
    end 
    add_index :o_embed_caches, :url

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

    create_table :share_visibilities do |t|
      t.integer :shareable_id
      t.boolean :hidden, :default => false, :null => false
      t.integer :contact_id, :null => false
      t.string   :shareable_type, :default => "Post", :null => false
      t.timestamps
    end
    add_index :share_visibilities, :contact_id
    add_index :share_visibilities, :shareable_id
    add_index :share_visibilities, [:shareable_id, :shareable_type, :contact_id]
    add_index :share_visibilities, [:shareable_id, :shareable_type, :hidden, :contact_id]

    add_foreign_key :share_visibilities, :contacts, :dependent => :delete

    create_table :aspect_visibilities do |t| 
      t.integer  :shareable_id,                       :null => false
      t.integer  :aspect_id,                          :null => false
      t.string   :shareable_type, :default => "Post", :null => false
      t.timestamps
    end 

    add_index :aspect_visibilities, [:aspect_id] 
    add_index :aspect_visibilities, [:shareable_id, :shareable_type, :aspect_id]
    add_index :aspect_visibilities, [:shareable_id, :shareable_type]

    add_foreign_key :aspect_visibilities, :aspects, :dependent => :delete

    create_table :profiles do |t|
      t.string :diaspora_handle
      t.string :first_name, :limit => 127
      t.string :last_name, :limit => 127
      t.string :full_name, :limit => 70
      t.string :image_url
      t.string :image_url_small
      t.string :image_url_medium
      t.date :birthday
      t.string :gender
      t.text :bio
      t.boolean :searchable, :default => true
      t.integer :person_id
      #这是什么的缩写
      t.boolean :nsfw, :default => false
      t.string :location
      t.timestamps
    end
    add_index :profiles, :full_name
    add_index :profiles, [:full_name, :searchable]
    add_index :profiles, :person_id, :unique => true

    create_table :services do |t|
      t.string :type, :limit => 127
      t.integer :user_id
      #t.string :provider
      t.string :uid, :limit => 127
      t.string :access_token
      t.string :access_secret
      t.string :nickname
      t.timestamps
    end
    add_index :services, :user_id
    add_index :services, [:type, :uid]

    create_table :users do |t|
      t.string :username
      t.text :serialized_private_key
      t.integer :invites, :default => 0
      t.boolean :getting_started, :default => true
      t.boolean :disable_mail, :default => false
      t.string :language

      t.string :email,              :null => false, :default => ""
      t.string :encrypted_password, :null => false, :default => ""

      t.string   :reset_password_token
      t.datetime :remember_created_at
      t.string   :remember_token
      t.integer  :sign_in_count, :default => 0
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      t.string :unconfirmed_email, :default => nil, :null => true
      t.string :confirm_email_token, :limit => 30
      t.datetime :locked_at
      t.boolean :auto_follow_back, :default => false
      t.integer :auto_follow_back_aspect_id
      t.timestamps
    end
    add_index :users, :username, :unique => true
    add_index :users, :email
    add_index :users, :invitation_token

    add_foreign_key(:comments, :people, :column => :author_id, :dependent => :delete)
    add_foreign_key(:posts, :people, :column => :author_id, :dependent => :delete)

    create_table :tags do |t| 
      t.string :name
    end 

    add_index :tags, :name, :unique => true

    create_table :taggings do |t| 
      t.references :tag
      # You should make sure that the column created is
      # long enough to store the required class names.
      t.references :taggable, :polymorphic => {:limit => 127}
      t.references :tagger, :polymorphic => {:limit => 127}

      t.string :context, :limit => 127 
      t.datetime :created_at
    end 

    add_index :taggings, :created_at
    add_index :taggings, :tag_id
    add_index :taggings, [:taggable_id, :taggable_type, :context]
    add_index :taggings, [:taggable_id, :taggable_type, :tag_id], :unique => true

    create_table :tag_followings do |t| 
      t.integer :tag_id, :null => false
      t.integer :user_id, :null => false

      t.timestamps
    end 

    add_index :tag_followings, :tag_id
    add_index :tag_followings, :user_id
    add_index :tag_followings, [:tag_id, :user_id], :unique => true      
  end

  def self.down
    raise "irreversable migration!"
  end
end
