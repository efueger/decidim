Decidim::CreateOmniauthRegistration.class_eval do
  def initialize(form, verified_email = nil, verified_name = nil)
      @form = form
      @verified_email = verified_email
      @verified_name = verified_name
    end

    # Executes the command. Broadcasts these events:
    #
    # - :ok when everything is valid.
    # - :invalid if the form wasn't valid and we couldn't proceed.
    #
    # Returns nothing.
  def call
    verify_oauth_signature!
    begin
      return broadcast(:ok, existing_identity.user) if existing_identity
      return broadcast(:invalid) if form.invalid?

      transaction do
        create_or_find_user
        create_identity
      end

      broadcast(:ok, @user)
    rescue ActiveRecord::RecordInvalid => error
      broadcast(:error, error.record)
    end
  end

  private

  attr_reader :form, :verified_email, :verified_name

  def create_or_find_user
    generated_password = SecureRandom.hex

    if form.provider == "saml"
      @user = Decidim::User.find_or_initialize_by(
        email: verified_email,
        uid_name: verified_name,
        organization: organization
      )
    else
      @user = Decidim::User.find_or_initialize_by(
        email: verified_email,
        organization: organization
      )
    end

    unless @user.persisted?
      @user.email = (verified_email || form.email)
      @user.name = form.name
      @user.nickname = form.normalized_nickname
      @user.newsletter_notifications = true
      @user.email_on_notification = true
      @user.skip_confirmation! if verified_email
      if form.provider == "saml"
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

  def create_identity
    @user.identities.create!(
      provider: form.provider,
      uid: form.uid,
      organization: organization
    )
  end

  def organization
    @form.current_organization
  end

  def existing_identity
    if form.provider == "saml"
      @existing_identity ||= Decidim::Identity.where(
        user: organization.users,
        provider: form.provider
      ).first
    else
      @existing_identity ||= Decidim::Identity.where(
        user: organization.users,
        provider: form.provider,
        uid: form.uid
      ).first
    end
  end

  def verify_oauth_signature!
    raise InvalidOauthSignature, "Invalid oauth signature: #{form.oauth_signature}" unless signature_valid?
  end

  def signature_valid?
    signature = Decidim::OmniauthRegistrationForm.create_signature(form.provider, form.uid)
    form.oauth_signature == signature
  end

  class InvalidOauthSignature < StandardError
  end
end
