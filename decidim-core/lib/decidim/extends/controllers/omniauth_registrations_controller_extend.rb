module OmniauthRegistrationsControllerExtend
  def create
    form_params = user_params_from_oauth_hash || params[:user]
    @form = form(Decidim::OmniauthRegistrationForm).from_params(form_params)
    @form.email ||= verified_email
    Decidim::CreateOmniauthRegistration.call(@form, verified_email, verified_name) do
      on(:ok) do |user|
        if user.active_for_authentication?
          sign_in_and_redirect user, event: :authentication
          set_flash_message :notice, :success, kind: t("decidim.devise.omniauth_registrations.#{@form.provider}")
        else
          expire_data_after_sign_in!
          redirect_to root_path
          flash[:notice] = t("devise.registrations.signed_up_but_unconfirmed")
        end
      end

      on(:invalid) do
        set_flash_message :notice, :success, kind: t("decidim.devise.omniauth_registrations.#{@form.provider}")
        render :new
      end

      on(:error) do |user|
        if user.errors[:email]
          set_flash_message :alert, :failure, kind: t("decidim.devise.omniauth_registrations.#{@form.provider}"), reason: t("decidim.devise.omniauth_registrations.create.email_already_exists")
        end

        render :new
      end
    end
  end
end

Decidim::Devise::OmniauthRegistrationsController.class_eval do
  prepend(OmniauthRegistrationsControllerExtend)
  private

  def verified_name
    if request.env["omniauth.auth"] && @form.provider == "saml"
      @verified_name ||= request.env["omniauth.auth"].extra.raw_info.attributes["uid"]
    elsif params["user"]&& params["user"]["uid_name"]
      @verified_name ||= params["user"]["uid_name"]
    end
  end

  def user_params_from_oauth_hash
    return nil unless request.env["omniauth.auth"]
    {
      provider: oauth_data[:provider],
      uid: oauth_data[:uid],
      name: (oauth_data[:info][:first_name] + ' ' + oauth_data[:info][:last_name]).strip,
      nickname: oauth_data[:info][:name],
      oauth_signature: Decidim::OmniauthRegistrationForm.create_signature(oauth_data[:provider], oauth_data[:uid])
    }
  end
end
