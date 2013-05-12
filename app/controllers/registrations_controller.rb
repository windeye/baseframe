# encoding: utf-8
class RegistrationsController < Devise::RegistrationsController
  layout "with_header", :only => [:new]
  #before_filter -> { @css_framework = :bootstrap }, only: [:new]

  def create
    params.each do |k,v|
      Rails.logger.info("#{k}:#{v}")
    end
    @user = User.build(params[:user])
    #@user.process_invite_acceptence(invite) if invite.present?

    if @user.save
      flash[:notice] = "注册成功"
      @user.seed_aspects
      sign_in_and_redirect(:user, @user)
      Rails.logger.info("event=registration status=successful user=#{@user.diaspora_handle}")
    else
      @user.errors.delete(:person)

      flash[:error] = @user.errors.full_messages.join(" - ")
      Rails.logger.info("event=registration status=failure errors='#{@user.errors.full_messages.join(', ')}'")
      redirect_to :back
    end
  end

  def new
    super
  end

end
