class AccountDeleter

  # Things that are not removed from the database:
  # - Comments
  # - Likes
  # - NotificationActors
  #
  # Given that the User in question will be tombstoned, all of the
  # above will come from an anonymized account (via the UI).
  # The deleted user will appear as "Deleted Account" in
  # the interface.

  attr_accessor :person, :user

  def initialize(diaspora_handle)
    self.person = Person.where(:diaspora_handle => diaspora_handle).first
    self.user = self.person.owner
  end

  def perform!
    #person
    delete_standard_person_associations
    remove_conversation_visibilities
    remove_share_visibilities_on_persons_posts
    delete_contacts_of_me
    tombstone_person_and_profile
    
    if self.user
      #user deletion methods
      remove_share_visibilities_on_contacts_posts
      delete_standard_user_associations
      disassociate_invitations
      disconnect_contacts
      tombstone_user
    end
  end

  #user deletions
  def normal_ar_user_associates_to_delete
    [:tag_followings, :services, :aspects, :user_preferences, :notifications, :blocks]
  end

  def special_ar_user_associations
    [:person, :contacts, :auto_follow_back_aspect]
  end

  def ignored_ar_user_associations
    [:followed_tags, :contact_people, :aspect_memberships, :ignored_people]
  end

  def delete_standard_user_associations
    normal_ar_user_associates_to_delete.each do |asso|
      self.user.send(asso).each{|model| model.delete}
    end
  end

  def delete_standard_person_associations
    normal_ar_person_associates_to_delete.each do |asso|
      self.person.send(asso).delete_all
    end
  end

  def disconnect_contacts
    user.contacts.destroy_all
  end

  # Currently this would get deleted due to the db foreign key constrainsts,
  # but we'll keep this method here for completeness
  def remove_share_visibilities_on_persons_posts
    ShareVisibility.for_contacts_of_a_person(person).destroy_all
  end

  def remove_share_visibilities_on_contacts_posts
    ShareVisibility.for_a_users_contacts(user).destroy_all
  end

  def tombstone_person_and_profile
    self.person.lock_access!
    self.person.clear_profile!
  end

  def tombstone_user
    self.user.clear_account!
  end

  def delete_contacts_of_me
    Contact.all_contacts_of_person(self.person).destroy_all
  end
  
  def normal_ar_person_associates_to_delete
    [:posts, :mentions, :roles]
  end

  def ignored_or_special_ar_person_associations
    [:comments, :contacts, :notification_actors, :notifications, :owner, :profile ]
  end
end
