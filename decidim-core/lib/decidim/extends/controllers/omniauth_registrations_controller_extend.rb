module OmniauthRegistrationsControllerExtend
  def create

    form_params = user_params_from_oauth_hash || params[:user]
    @form = form(OmniauthRegistrationForm).from_params(form_params)
    @form.email ||= verified_email

    CreateOmniauthRegistration.call(@form, verified_email) do
      on(:ok) do |user|
        if user.active_for_authentication?
          sign_in_and_redirect user, event: :authentication
          set_flash_message :notice, :success, kind: t(".#{@form.provider.capitalize}")
        else
          expire_data_after_sign_in!
          redirect_to root_path
          flash[:notice] = t("devise.registrations.signed_up_but_unconfirmed")
        end
      end

      on(:invalid) do
        set_flash_message :notice, :success, kind: t(".#{@form.provider.capitalize}")
        render :new
      end

      on(:error) do |user|
        if user.errors[:email]
          set_flash_message :alert, :failure, kind: t(".#{@form.provider.capitalize}"), reason: t("decidim.devise.omniauth_registrations.create.email_already_exists")
        end

        render :new
      end
    end
  end
end

Decidim::OmniauthRegistrationsController.class_eval do
  prepend(OmniauthRegistrationsControllerExtend)
end
