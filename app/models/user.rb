#   Copyright (c) 2010-2011, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.

class User < ActiveRecord::Base

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :token_authenticatable, :lockable, :lock_strategy => :none,
         :unlock_strategy => :none


  attr_accessible :username,
                  :email,
                  :getting_started,
                  :password,
                  :password_confirmation,
                  :language,
                  :disable_mail,
                  :invitation_service,
                  :invitation_identifier,
                  :show_community_spotlight_in_stream,
                  :auto_follow_back,
                  :auto_follow_back_aspect_id,
                  :remember_me

end
