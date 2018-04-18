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

    @user = Decidim::User.find_or_initialize_by(
      email: verified_email,
      organization: organization,
      name: verified_name
    )

    unless @user.persisted?
      @user.email = (verified_email || form.email)
      @user.name = (verified_name || form.name)
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
end
