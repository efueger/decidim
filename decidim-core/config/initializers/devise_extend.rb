Devise.setup do |config|
  if Rails.application.secrets.dig(:omniauth, :saml).present?
    config.omniauth :saml,
      idp_sso_target_url: Rails.application.secrets.omniauth[:saml][:idp_sso_target_url],
      assertion_consumer_service_url: Rails.application.secrets.omniauth[:saml][:assertion_consumer_service_url],
      authn_context: Rails.application.secrets.omniauth[:saml][:authn_context],
      issuer: Rails.application.secrets.omniauth[:saml][:issuer],
      name_identifier_format: Rails.application.secrets.omniauth[:saml][:name_identifier_format],
      protocol_binding: Rails.application.secrets.omniauth[:saml][:protocol_binding],
      idp_cert: Rails.application.secrets.omniauth[:saml][:idp_cert]
      # , authn_context_comparison: Rails.application.secrets.omniauth[:saml][:authn_context_comparison]
  end
end
