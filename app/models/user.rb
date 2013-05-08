class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  # devise :database_authenticatable, :registerable,
  #        :recoverable, :rememberable, :trackable, :validatable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :token_authenticatable, :lockable, :lock_strategy => :none,
         :unlock_strategy => :none    

  # Setup accessible (or protected) attributes for your model
  # attr_accessible :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body

  attr_accessible :username,:email,:getting_started,:password,
        :password_confirmation,:language,:disable_mail,
        :show_community_spotlight_in_stream,:auto_follow_back,
        :auto_follow_back_aspect_id,:remember_me  
end
