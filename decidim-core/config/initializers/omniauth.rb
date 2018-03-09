Rails.application.config.middleware.use OmniAuth::Builder do
  provider :saml,
    :assertion_consumer_service_url     => "consumer_service_url",
    :issuer                             => "rails-application",
    :idp_sso_target_url                 => "https://happy-dev.okta.com/app/happydev_dcd_1/exksz7yycwdXj2H8g2p6/sso/saml",
    :idp_sso_target_url_runtime_params  => {:original_request_param => :mapped_idp_param},
    :idp_cert                           => "MIIDojCCAoqgAwIBAgIGAWILr6iiMA0GCSqGSIb3DQEBCwUAMIGRMQswCQYDVQQGEwJVUzETMBEG
A1UECAwKQ2FsaWZvcm5pYTEWMBQGA1UEBwwNU2FuIEZyYW5jaXNjbzENMAsGA1UECgwET2t0YTEU
MBIGA1UECwwLU1NPUHJvdmlkZXIxEjAQBgNVBAMMCWhhcHB5LWRldjEcMBoGCSqGSIb3DQEJARYN
aW5mb0Bva3RhLmNvbTAeFw0xODAzMDkxNjUzNDRaFw0yODAzMDkxNjU0NDNaMIGRMQswCQYDVQQG
EwJVUzETMBEGA1UECAwKQ2FsaWZvcm5pYTEWMBQGA1UEBwwNU2FuIEZyYW5jaXNjbzENMAsGA1UE
CgwET2t0YTEUMBIGA1UECwwLU1NPUHJvdmlkZXIxEjAQBgNVBAMMCWhhcHB5LWRldjEcMBoGCSqG
SIb3DQEJARYNaW5mb0Bva3RhLmNvbTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAJNr
xX+NiNoo9UX2Xl42qBwKFo/YdEzhpJw1T7ySqyASkjWEofHWjyoP/oytskxaJjHoHLQJ6ufYLlx0
H248H8E/dncw/E/n6RstqNU4TNkafT37FNF6ofYeZdSvq5IyhrjrAHUYMtmSz55sB4v8Vdcw34kl
3O6dmeLqjsjM41dC7QOGpKPh/7YTSLVmd7nFpIIkpcklh7sZO8wNEvdLl34arEvQpZ3n1r2p7j/2
H9YuEG7lE7mbODYfd7vfYxdgUYCoAbVTSQXjy8Ukm7jznlLMZQSIWfTps5ME7Xnu6b3CR03j3jmy
0SRTQCQcTplw46ALYQ7gqVG5fcDEbnlt9qMCAwEAATANBgkqhkiG9w0BAQsFAAOCAQEAKejdU/Wn
9XM2dFH8mULaurCpocscla5p5e13Co6HmSvwa4rRlWNpbv7P3Mof/CzSidkjebLHHg8RhN/NzHP+
4Ali4FgpRMDWbw6jpI5VmMIMf2dJKI/+jeZ7J13v4xFecWrSasUbrAR357A58F3urJxll96VSW3J
F66TWAUPlyfbwz5imlO4JD13wxYEtCmXTQOTGJqCsN1rM6O0r3eu4t3TGa2gXYTrwszbI0y+yGDS
RvXwsaDFTa5Nb9iex62OegoI8nwVAOPSli/C8EjpgFpcElFgEq2g4DbaCWJaKN/nTOKVln8H32yG
TPRjrMg5bdlVdnP5OiNDYrLC+DgFjQ==",
    :idp_cert_fingerprint               => '33:66:B6:FF:DD:C4:D4:F4:9E:FC:B6:FC:74:42:E4:C3:79:B0:3B:02:00:4A:2D:B5:81:26:35:22:8D:C8:AB:CF',
    :idp_cert_fingerprint_validator     => lambda { |fingerprint| fingerprint },
    :name_identifier_format             => "urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress"
end