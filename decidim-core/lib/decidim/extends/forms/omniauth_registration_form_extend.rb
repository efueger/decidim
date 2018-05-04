Decidim::OmniauthRegistrationForm.class_eval do
  attribute :password, String
  attribute :password_confirmation, String
  attribute :uid_name, String
  attribute :newsletter, Virtus::Attribute::Boolean

  attribute :nickname, String
  attribute :tos_agreement, Virtus::Attribute::Boolean

  validates :password, presence: true
  validates :password_confirmation, presence: true

  validates :tos_agreement, allow_nil: false, acceptance: true

end
