# Rails.application.config.middleware.use OmniAuth::Builder do
#   provider :saml,
#     :assertion_consumer_service_url     => "http://dcd.local.osp.cat:3000/auth/saml",
#     :issuer                             => "Decidim BOSA",
#     :idp_sso_target_url                 => Rails.application.secrets.omniauth[:saml][:idp_sso_target_url],
#     :idp_sso_target_url_runtime_params  => {:original_request_param => :mapped_idp_param},
#     :idp_cert                           => "MIIFhDCCA2wCCQDmonCvtnBCiTANBgkqhkiG9w0BAQsFADCBgzELMAkGA1UEBhMC
# RlIxDjAMBgNVBAgMBVBhcmlzMQ4wDAYDVQQHDAVQYXJpczEbMBkGA1UECgwST3Bl
# blNvdXJjZVBvbGl0aWNzMRowGAYDVQQDDBFkY2QubG9jYWwub3NwLmNhdDEbMBkG
# CSqGSIb3DQEJARYMbWFrb0Bvc3AuY2F0MB4XDTE4MDMyMDEyMDYxMloXDTI4MDMx
# OTEyMDYxMlowgYMxCzAJBgNVBAYTAkZSMQ4wDAYDVQQIDAVQYXJpczEOMAwGA1UE
# BwwFUGFyaXMxGzAZBgNVBAoMEk9wZW5Tb3VyY2VQb2xpdGljczEaMBgGA1UEAwwR
# ZGNkLmxvY2FsLm9zcC5jYXQxGzAZBgkqhkiG9w0BCQEWDG1ha29Ab3NwLmNhdDCC
# AiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBAM5Bpe1hHJHlEBjNE4yTvzuL
# l50QNKQ/X4YepcxIDlY2L3kOYJ8hD7JkpE8szk/irwaleGn7DdpJ2KE37wTzHLGe
# zE1IkUsRg/7cKVuYkbiLRbAGAULV1uhRUYymIQrPCgKBRjzT2wp9dIMZW1t/warQ
# 6jN1whuPEib7kiBD1vw2BEVvkiyYdKuyXIpwTy+BiDxjq5BB0+x02PoIawmVukay
# Sr1AdRkMK2LQplJuT8hXP/1w/BazjA6hZIqMgYHPZUpOf6vw4GpHZOIEbPd/5HZB
# SzSLv4O8UJGKn2U139BLfeodItptl8m7ikmYQvDQdeQpWykAOsC9J1SPdgsrATDR
# cGvk7x9RxLXDGslI90WmMKoxkRsiQszvxggUq6B7oNthecGuMAW9Sf2BSeVZ0XWR
# dg3EsU8YtZZQ++pLJlmmsSwVT79C8Qb06fLWmVbuUMb+frJOtAHHswIMDeKq6Pew
# SKisTq2l/LQsUeVlNyxsBOd/3mzSqtoXELsGSNzM2JwjlIcnN4/zSfWUPh4Edwwb
# k/tUYYkGX9DI9A+dN7aqLVFmPhU8+TkdH6h/sC+ACs1fA3gXTU+wYqK/DCE4JZux
# iWdIbk/wLLOWXKLLS2H6RhoTP8oxYCLP2OhwTiL+WcQkCOlwQa8zWjMc4rWXqcMU
# PEdOvn43hFOMDVoPxj2LAgMBAAEwDQYJKoZIhvcNAQELBQADggIBAAqD40FkhvbU
# vH+BMIXUlzkotFcimQWryytJs9EpYfaRPa/gXpSvDb55jNz9GLEdr8Xw7vXfHkCv
# 4Xs3CGTBRKrK8e7+C0rb/HbsWPFWpz37zyrzruMuowXtMKtdqcJUr6VZUqdpnvyV
# 4/nSNrmtcHwq1TVZ9+shyz5NsmolQN+sD9u9stJMPulGfprcGKlM+IeOTOOzIoNW
# 90pd5HDOk7UMTXKZ61CmT4PVSR4sDF0Is3FPhXFthLmS9sSJT7BNX4HyoSh1sNQ3
# /kJXFNfemI3UfV9Evk40y37/yOPCNfJsmHrzRhFKXkraHiFaN0Up0Tgl2fmBeZnE
# hP4/4Srn95NDdYR5VkzR5GaNvxZLF2TwNdKU/Mx81DvLt6HeiABkx4wu34ZRUAUT
# 1eMpslPDWtEt917VXnSm7JfvdFoWtvOTEgw2hf/kHAudrZn3/EciPwPydVZYpzx4
# UPtS0nFdfm4Bst/HAQFVbQ6/cKG9sTAS0AADxw+2dnZ71uqLnqeHoVUODa+uiC4o
# 0eNjGY+cKmzWgq2Q6GKVuK+ErGLShtQAFKptyhwJqnDg977YKUXT/Xo8yqa/IgEI
# eVRvW9pSxB70SAwNZBfM6IIPxij2Fu+lRukDg9pzCF7BZb2pEnJi7IT7YsZIsPBg
# EgCPf3V2Hf+X3ZxYJr3jx2sjZbOdNlHS",
#     :idp_cert_fingerprint               => Rails.application.secrets.omniauth[:saml][:idp_cert_fingerprint],
#     :idp_cert_fingerprint_validator     => lambda { |fingerprint| fingerprint },
#     # :name_identifier_format             => "context:urn:be:fedict:iam:fas:citizen:Level450",
#     :spAuthncontextComparisonType       => "minimun"
# end