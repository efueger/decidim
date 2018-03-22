# frozen_string_literal: true

# Use this hook to configure devise mailer, warden hooks and so forth.
# Many of these configuration options can be set straight in your model.

Devise.setup do |config|
  # The secret key used by Devise. Devise uses this key to generate
  # random tokens. Changing this key will render invalid all existing
  # confirmation, reset password and unlock tokens in the database.
  # Devise will use the `secret_key_base` as its `secret_key`
  # by default. You can change it below and use your own secret key.
  # config.secret_key = 'e1f4e9899fb5e8b3123950b19cd0f6d22ecaa8c7fb792b6db5a939edc2b3bab722d06a6a46345ee9bf12caa0178408d6134ea92ed778977b8a7ed1007a0c6dbe'

  # ==> Mailer Configuration
  # Configure the e-mail address which will be shown in Devise::Mailer,
  # note that it will be overwritten if you use your own mailer class
  # with default "from" parameter.
  config.mailer_sender = Decidim.config.mailer_sender

  # Configure the class responsible to send e-mails.
  config.mailer = "Decidim::DecidimDeviseMailer"

  # Configure the parent class responsible to send e-mails.
  config.parent_mailer = "Decidim::ApplicationMailer"

  config.parent_controller = "ActionController::Base"

  # ==> ORM configuration
  # Load and configure the ORM. Supports :active_record (default) and
  # :mongoid (bson_ext recommended) by default. Other ORMs may be
  # available as additional gems.
  require "devise/orm/active_record"

  # ==> Configuration for any authentication mechanism
  # Configure which keys are used when authenticating a user. The default is
  # just :email. You can configure it to use [:username, :subdomain], so for
  # authenticating a user, both parameters are required. Remember that those
  # parameters are used only when authenticating and not when retrieving from
  # session. If you need permissions, you should implement that in a before filter.
  # You can also supply a hash where the value is a boolean determining whether
  # or not authentication should be aborted when the value is not present.
  # config.authentication_keys = [:email]

  # Configure parameters from the request object used for authentication. Each entry
  # given should be a request method and it will automatically be passed to the
  # find_for_authentication method and considered in your model lookup. For instance,
  # if you set :request_keys to [:subdomain], :subdomain will be used on authentication.
  # The same considerations mentioned for authentication_keys also apply to request_keys.
  # config.request_keys = []

  # Configure which authentication keys should be case-insensitive.
  # These keys will be downcased upon creating or modifying a user and when used
  # to authenticate or find a user. Default is :email.
  config.case_insensitive_keys = [:email]

  # Configure which authentication keys should have whitespace stripped.
  # These keys will have whitespace before and after removed upon creating or
  # modifying a user and when used to authenticate or find a user. Default is :email.
  config.strip_whitespace_keys = [:email]

  # Tell if authentication through request.params is enabled. True by default.
  # It can be set to an array that will enable params authentication only for the
  # given strategies, for example, `config.params_authenticatable = [:database]` will
  # enable it only for database (email + password) authentication.
  # config.params_authenticatable = true

  # Tell if authentication through HTTP Auth is enabled. False by default.
  # It can be set to an array that will enable http authentication only for the
  # given strategies, for example, `config.http_authenticatable = [:database]` will
  # enable it only for database authentication. The supported strategies are:
  # :database      = Support basic authentication with authentication key + password
  # config.http_authenticatable = false

  # If 401 status code should be returned for AJAX requests. True by default.
  # config.http_authenticatable_on_xhr = true

  # The realm used in Http Basic Authentication. 'Application' by default.
  # config.http_authentication_realm = 'Application'

  # It will change confirmation, password recovery and other workflows
  # to behave the same regardless if the e-mail provided was right or wrong.
  # Does not affect registerable.
  # config.paranoid = true

  # By default Devise will store the user in session. You can skip storage for
  # particular strategies by setting this option.
  # Notice that if you are skipping storage for all authentication paths, you
  # may want to disable generating routes to Devise's sessions controller by
  # passing skip: :sessions to `devise_for` in your config/routes.rb
  config.skip_session_storage = [:http_auth]

  # By default, Devise cleans up the CSRF token on authentication to
  # avoid CSRF token fixation attacks. This means that, when using AJAX
  # requests for sign in and sign up, you need to get a new CSRF token
  # from the server. You can disable this option at your own risk.
  # config.clean_up_csrf_token_on_authentication = true

  # When false, Devise will not attempt to reload routes on eager load.
  # This can reduce the time taken to boot the app but if your application
  # requires the Devise mappings to be loaded during boot time the application
  # won't boot properly.
  # config.reload_routes = true

  # ==> Configuration for :database_authenticatable
  # For bcrypt, this is the cost for hashing the password and defaults to 11. If
  # using other algorithms, it sets how many times you want the password to be hashed.
  #
  # Limiting the stretches to just one in testing will increase the performance of
  # your test suite dramatically. However, it is STRONGLY RECOMMENDED to not use
  # a value less than 10 in other environments. Note that, for bcrypt (the default
  # algorithm), the cost increases exponentially with the number of stretches (e.g.
  # a value of 20 is already extremely slow: approx. 60 seconds for 1 calculation).
  config.stretches = Rails.env.test? ? 1 : 11

  # Set up a pepper to generate the hashed password.
  # config.pepper = 'da466a45a1744ca79cc920a565749cf42b1cbcda0478b299a0db973e1a157fc43d1f578ec8dd393b4ef104274272a3621d203f49f473432a46b8a28ecc9bb4ae'

  # Send a notification email when the user's password is changed
  # config.send_password_change_notification = false

  # ==> Configuration for :invitable
  # The period the generated invitation token is valid, after
  # this period, the invited resource won't be able to accept the invitation.
  # When invite_for is 0 (the default), the invitation won't expire.
  config.invite_for = 2.weeks

  # Number of invitations users can send.
  # - If invitation_limit is nil, there is no limit for invitations, users can
  # send unlimited invitations, invitation_limit column is not used.
  # - If invitation_limit is 0, users can't send invitations by default.
  # - If invitation_limit n > 0, users can send n invitations.
  # You can change invitation_limit column for some users so they can send more
  # or less invitations, even with global invitation_limit = 0
  # Default: nil
  # config.invitation_limit = 5

  # The key to be used to check existing users when sending an invitation
  # and the regexp used to test it when validate_on_invite is not set.
  # config.invite_key = {:email => /\A[^@]+@[^@]+\z/}
  # config.invite_key = {:email => /\A[^@]+@[^@]+\z/, :username => nil}

  # Flag that force a record to be valid before being actually invited
  # Default: false
  # config.validate_on_invite = true

  # Resend invitation if user with invited status is invited again
  # Default: true
  # config.resend_invitation = false

  # The class name of the inviting model. If this is nil,
  # the #invited_by association is declared to be polymorphic.
  # Default: nil
  # config.invited_by_class_name = 'User'

  # The foreign key to the inviting model (if invited_by_class_name is set)
  # Default: :invited_by_id
  # config.invited_by_foreign_key = :invited_by_id

  # The column name used for counter_cache column. If this is nil,
  # the #invited_by association is declared without counter_cache.
  # Default: nil
  # config.invited_by_counter_cache = :invitations_count

  # Auto-login after the user accepts the invite. If this is false,
  # the user will need to manually log in after accepting the invite.
  # Default: true
  config.allow_insecure_sign_in_after_accept = true

  # ==> Configuration for :confirmable
  # A period that the user is allowed to access the website even without
  # confirming their account. For instance, if set to 2.days, the user will be
  # able to access the website for two days without confirming their account,
  # access will be blocked just in the third day. Default is 0.days, meaning
  # the user cannot access the website without confirming their account.
  # config.allow_unconfirmed_access_for = 2.days

  # A period that the user is allowed to confirm their account before their
  # token becomes invalid. For example, if set to 3.days, the user can confirm
  # their account within 3 days after the mail was sent, but on the fourth day
  # their account can't be confirmed with the token any more.
  # Default is nil, meaning there is no restriction on how long a user can take
  # before confirming their account.
  # config.confirm_within = 3.days

  # If true, requires any email changes to be confirmed (exactly the same way as
  # initial account confirmation) to be applied. Requires additional unconfirmed_email
  # db field (see migrations). Until confirmed, new email is stored in
  # unconfirmed_email column, and copied to email column on successful confirmation.
  config.reconfirmable = true

  # Defines which key will be used when confirming an account
  # config.confirmation_keys = [:email]

  # ==> Configuration for :rememberable
  # The time the user will be remembered without asking for credentials again.
  # config.remember_for = 2.weeks

  # Invalidates all the remember me tokens when the user signs out.
  config.expire_all_remember_me_on_sign_out = true

  # If true, extends the user's remember period when remembered via cookie.
  # config.extend_remember_period = false

  # Options to be passed to the created cookie. For instance, you can set
  # secure: true in order to force SSL only cookies.
  # config.rememberable_options = {}

  # ==> Configuration for :validatable
  # Range for password length.
  config.password_length = 6..128

  # Email regex used to validate email formats. It simply asserts that
  # one (and only one) @ exists in the given string. This is mainly
  # to give user feedback and not to assert the e-mail validity.
  config.email_regexp = /\A[^@\s]+@[^@\s]+\z/

  # ==> Configuration for :timeoutable
  # The time you want to timeout the user session without activity. After this
  # time the user will be asked for credentials again. Default is 30 minutes.
  # config.timeout_in = 30.minutes

  # ==> Configuration for :lockable
  # Defines which strategy will be used to lock an account.
  # :failed_attempts = Locks an account after a number of failed attempts to sign in.
  # :none            = No lock strategy. You should handle locking by yourself.
  # config.lock_strategy = :failed_attempts

  # Defines which key will be used when locking and unlocking an account
  # config.unlock_keys = [:email]

  # Defines which strategy will be used to unlock an account.
  # :email = Sends an unlock link to the user email
  # :time  = Re-enables login after a certain amount of time (see :unlock_in below)
  # :both  = Enables both strategies
  # :none  = No unlock strategy. You should handle unlocking by yourself.
  # config.unlock_strategy = :both

  # Number of authentication tries before locking an account if lock_strategy
  # is failed attempts.
  # config.maximum_attempts = 20

  # Time interval to unlock the account if :time is enabled as unlock_strategy.
  # config.unlock_in = 1.hour

  # Warn on the last attempt before the account is locked.
  # config.last_attempt_warning = true

  # ==> Configuration for :recoverable
  #
  # Defines which key will be used when recovering the password for an account
  # config.reset_password_keys = [:email]

  # Time interval you can reset your password with a reset password key.
  # Don't put a too small interval or your users won't have the time to
  # change their passwords.
  config.reset_password_within = 6.hours

  # When set to false, does not sign a user in automatically after their password is
  # reset. Defaults to true, so a user is signed in automatically after a reset.
  # config.sign_in_after_reset_password = true

  # ==> Configuration for :encryptable
  # Allow you to use another hashing or encryption algorithm besides bcrypt (default).
  # You can use :sha1, :sha512 or algorithms from others authentication tools as
  # :clearance_sha1, :authlogic_sha512 (then you should set stretches above to 20
  # for default behavior) and :restful_authentication_sha1 (then you should set
  # stretches to 10, and copy REST_AUTH_SITE_KEY to pepper).
  #
  # Require the `devise-encryptable` gem when using anything other than bcrypt
  # config.encryptor = :sha512

  # ==> Scopes configuration
  # Turn scoped views on. Before rendering "sessions/new", it will first check for
  # "users/sessions/new". It's turned off by default because it's slower if you
  # are using only default views.
  config.scoped_views = true

  # Configure the default scope given to Warden. By default it's the first
  # devise role declared in your routes (usually :user).
  # config.default_scope = :user

  # Set this configuration to false if you want /users/sign_out to sign out
  # only the current scope. By default, Devise signs out all scopes.
  # config.sign_out_all_scopes = true

  # ==> Navigation configuration
  # Lists the formats that should be treated as navigational. Formats like
  # :html, should redirect to the sign in page when the user does not have
  # access, but formats like :xml or :json, should return 401.
  #
  # If you have any extra navigational formats, like :iphone or :mobile, you
  # should add them to the navigational formats lists.
  #
  # The "*/*" below is required to match Internet Explorer requests.
  # config.navigational_formats = ['*/*', :html]

  # The default HTTP method used to sign out a resource. Default is :delete.
  config.sign_out_via = :delete

  # ==> OmniAuth
  # Add a new OmniAuth provider. Check the wiki for more information on setting
  # up on your models and hooks.

#     config.omniauth :saml,
#       assertion_consumer_service_url:     "http://dcd.local.osp.cat:3000/users/saml/auth",
#       issuer:                             "http://dcd.local.osp.cat:3000/users/saml/metadata",
#       authn_context:                      "urn:oasis:names:tc:SAML:2.0:ac:classes:PasswordProtectedTransport",

#       #line configuration
#       idp_sso_target_url:                 "https://idp.iamfas.belgium.be/fas/SSORedirect/metaAlias/idp",
#       idp_cert_fingerprint:               "B5:19:B2:01:C2:34:60:71:82:93:34:0B:EA:7A:E3:BA:EA:D7:CE:63:DC:0B:17:32:51:0B:31:19:E0:5E:B9:B3",
#       idp_cert_fingerprint_algorithm:     'http://www.w3.org/2000/09/xmldsig#sha256',
#       name_identifier_format:             "context:urn:be:fedict:iam:fas:citizen:Level450",
#       authn_context_comparison:       "minimun",
#       idp_cert: "-----BEGIN CERTIFICATE-----
# MIIFdDCCA1wCCQDn4xP4v1+3IzANBgkqhkiG9w0BAQsFADB8MQswCQYDVQQGEwJG
# UjEOMAwGA1UECAwFUGFyaXMxHTAbBgNVBAoMFE9wZW4gU291cmNlIFBvbGl0aWNz
# MSEwHwYDVQQDDBhodHRwOi8vZGNkLmxvY2FsLm9zcC5jYXQxGzAZBgkqhkiG9w0B
# CQEWDG1ha29Ab3NwLmNhdDAeFw0xODAzMjAxNzE2NDRaFw0yODAzMTkxNzE2NDRa
# MHwxCzAJBgNVBAYTAkZSMQ4wDAYDVQQIDAVQYXJpczEdMBsGA1UECgwUT3BlbiBT
# b3VyY2UgUG9saXRpY3MxITAfBgNVBAMMGGh0dHA6Ly9kY2QubG9jYWwub3NwLmNh
# dDEbMBkGCSqGSIb3DQEJARYMbWFrb0Bvc3AuY2F0MIICIjANBgkqhkiG9w0BAQEF
# AAOCAg8AMIICCgKCAgEAs2P0WIIDGGsMqmSU1ToMUELoSk43AwCz0JQwRGEYwwUQ
# f06cR1JTrZXDkN6x0E0JX5AhEKdfNQ3fsk/Swy9uK3u+5zfjFviBLiVTb2TLmflB
# lclQhJhMGDjwBFWK2bqZEcBjsD0sQx/nEdV8QhwTHfcBt7cFQ3HoZ/41UO1Raa66
# wFcNay5LK4WD7jkV0rqFZp9Eo65Q0p1oXN3PUDsh+XyaK2DhUjEAzyGkRTS5dsDN
# HD+t0QN7kRxtDqgpOsvVwy1TNcNTZU4pgOAK883Lmvg6Z104nZ5RzmZR3gDDmwk1
# tuzOipLQCrcOpQ/A423VJvpI2CmcmlJrZz5kEZdAcWHoBLRqieIlBmGzzZbDxJAy
# csUM9iOpqWgrJPvEdQdUQxhElNBUJotFpOoYzke/QdYHMVQ2TXo6FA3Zd/BIXiNr
# n+/R1jyA7m1BwINt9//fPH9QAX4hY/9LjAJhvGIVa08Ow/Wr3EYOH+SfJYRNqzs9
# bT31PRCZOD6ReZSX2aMU9TryLsj/HvZsmRHL6vEmCHWUzQsmrI/J03yAHBZbTFlz
# 65W6qFe5gBSreS9RynePAcO8oW0LeF0zWUQB3FwCFwhoLE2r6Z/qS46Pf9sy1UjF
# q4pyinzAze30MpLCmui1Sn8IEGiMO4FCtRDts+x4ZH1vLEWMc2jVm8Z8Eohkcr8C
# AwEAATANBgkqhkiG9w0BAQsFAAOCAgEAfj9MWpwp4eePoAEc7cRKEYO46OL3/NZP
# Rp0a07oxrp/HTaOlD7Osir1WCXP56CCP/HIcpw4IB/nW9fr4j8TQoPtTL2UzFgdW
# 8iu+VyZ9HqScUTYbL3ALAO6CORQfOnJ9/4ivTOJhcibHwe21DCgJCs6sPshJC3y0
# ZeGE/IVdPFHMdnn52B4YAaq2zBz3icWvWFu3RpEtCgLsmc24bX+SYxPhIf9kCVwN
# Rf8zvYQA4wK/oAfKGfAkzw34GfrVeVveK1UZTrsWDd9sf3XnQ/SdyDRDOy/bMpZA
# I0kkS31ZdpMmb/gyOnm2kn9mCnBMvtEyf/ybP26g0kRywUGkAEKgPaf4WrRWtGIy
# 7p+AWQV/Xe01upFcpqiL4Yl2WElklU9vTBkCFo6i7HppCvP+NZcvMtyZNXZEICre
# hYK+h5jGp88IrcoKmHVJmun2w+ATAK5yPRiIjzCdKMXvWZlRS3WSHJch8F2LslBq
# wHMMjswjz6jYT+fPzQiAsVgd0m9E0HA0X+I5FESY1As48ZFmgJ092+dpZ5CPdQlM
# PfhRc1MzhN8DbDTQrtda0Ofgp5BOtQ8umhbEIB/8bMJVzUS8egtywU7Yer0GtC1D
# tX1A+7ccyd3JEgFQbEUmbgr8LRzT/cND0EziGMsfzVlwKMkDn0Na4d3CDuOQHMyT
# qwp553T/h1I=
# -----END CERTIFICATE-----
# ",
# key_descriptor: "signin",
# single_logout_service_location: "https://monopinion.belgium.be/auth/saml/slo",
# assertion_consumer_service_location: "https://monopinion.belgium.be/auth/saml/callback"
  if Rails.application.secrets.dig(:omniauth, :saml).present?
    config.omniauth :saml,
      idp_sso_target_url: Rails.application.secrets.omniauth[:saml][:idp_sso_target_url],
      idp_cert_fingerprint: Rails.application.secrets.omniauth[:saml][:idp_cert_fingerprint],
      assertion_consumer_service_url: Rails.application.secrets.omniauth[:saml][:assertion_consumer_service_url],
      redirect_uri: Rails.application.secrets.omniauth[:saml][:redirect_uri],
      idp_cert: Rails.application.secrets.omniauth[:saml][:idp_cert],
      issuer: Rails.application.secrets.omniauth[:saml][:issuer],
      name_identifier_format: Rails.application.secrets.omniauth[:saml][:name_identifier_format],
      authn_context: Rails.application.secrets.omniauth[:saml][:authn_context],
      protocol_binding: Rails.application.secrets.omniauth[:saml][:protocol_binding],
      secret_key: Rails.application.secrets.omniauth[:saml][:secret_key]
  end

  config.omniauth :developer, fields: [:name, :nickname, :email] if Rails.application.secrets.dig(:omniauth, :developer).present?
  if Rails.application.secrets.dig(:omniauth, :facebook).present?
    config.omniauth :facebook,
                    Rails.application.secrets.omniauth[:facebook][:app_id],
                    Rails.application.secrets.omniauth[:facebook][:app_secret],
                    scope: :email,
                    info_fields: "name,email,verified"
  end
  if Rails.application.secrets.dig(:omniauth, :twitter).present?
    config.omniauth :twitter,
                    Rails.application.secrets.omniauth[:twitter][:api_key],
                    Rails.application.secrets.omniauth[:twitter][:api_secret]
  end
  if Rails.application.secrets.dig(:omniauth, :google_oauth2).present?
    config.omniauth :google_oauth2,
                    Rails.application.secrets.omniauth[:google_oauth2][:client_id],
                    Rails.application.secrets.omniauth[:google_oauth2][:client_secret]
  end

  # ==> Warden configuration
  # If you want to use other strategies, that are not supported by Devise, or
  # change the failure app, you can configure them inside the config.warden block.
  #
  config.warden do |manager|
    manager.failure_app = Decidim::DeviseFailureApp
  end

  # ==> Mountable engine configurations
  # When using Devise inside an engine, let's call it `MyEngine`, and this engine
  # is mountable, there are some extra configurations to be taken into account.
  # The following options are available, assuming the engine is mounted as:
  #
  #     mount MyEngine, at: '/my_engine'
  #
  # The router that invoked `devise_for`, in the example above, would be:
  # config.router_name = :decidim
  #
  # When using OmniAuth, Devise cannot automatically set OmniAuth path,
  # so you need to do it manually. For the users scope, it would be:
  # config.omniauth_path_prefix = '/my_engine/users/auth'
end
