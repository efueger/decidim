
module CreateOmniauthRegistrationExtend
  def create_or_find_user

    @user = Decidim::User.find_or_initialize_by(
      email: verified_email,
      organization: organization
    )

    unless @user.persisted?
      @user.email = (verified_email || form.email)
      @user.name = form.name
      @user.nickname = form.normalized_nickname
      @user.newsletter_notifications = true
      @user.email_on_notification = true
      @user.password = form.password
      @user.password_confirmation = form.password_confirmation
      @user.skip_confirmation! if verified_email
    end

    @user.tos_agreement = "1"
    @user.save!
  end

end

Decidim::CreateOmniauthRegistration.class_eval do
  prepend(CreateOmniauthRegistrationExtend)
end
