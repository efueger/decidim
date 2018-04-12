
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
      @user.skip_confirmation! if verified_email
      if form.provider.uid == "saml"
        @user.password = form.password
        @user.password_confirmation = form.password_confirmation
      else
        @user.password = generated_password
        @user.password_confirmation = generated_password
      end
    end

    @user.tos_agreement = "1"
    @user.save!
  end

end

Decidim::CreateOmniauthRegistration.class_eval do
  prepend(CreateOmniauthRegistrationExtend)
end
