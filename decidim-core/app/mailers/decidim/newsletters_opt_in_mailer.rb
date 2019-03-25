# frozen_string_literal: true

module Decidim
  # A custom mailer for Decidim so we can notify users to verify
  # his own newsletter notifications settings. GDPR releated
  class NewslettersOptInMailer < ApplicationMailer
    # TODO: REMOVE the "default from: Decidim.config.mailer_sender"
    # The :from should've been inherited from ApplicationMailer
    # For an unknown reason, it doesn't
    default from: Decidim.config.mailer_sender

    def notify(user, token)
      @user = user
      @organization = user.organization
      @token = token

      mail(to: user.email, subject: I18n.t("decidim.newsletters_opt_in_mailer.notify.subject", organization_name: @organization.name))
    end
  end
end
