Decidim::OmniauthRegistrationForm.class_eval do
  attribute :password, String
  attribute :password_confirmation, String
  attribute :uid_name, String

  validates :password, presence: true
  validates :password_confirmation, presence: true
end
