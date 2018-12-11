# frozen_string_literal: true

module Decidim
  module Admin
    # A form object used to update the current organization appearance from the admin
    # dashboard.
    #
    class OrganizationAppearanceForm < Form
      include TranslatableAttributes

      mimic :organization

      attribute :homepage_image
      attribute :remove_homepage_image
      attribute :logo
      attribute :remove_logo
      attribute :favicon
      attribute :remove_favicon
      attribute :official_img_header
      attribute :remove_official_img_header
      attribute :official_img_footer
      attribute :remove_official_img_footer
      attribute :official_url
      attribute :show_statistics, Boolean
      attribute :header_snippets, String
      attribute :cta_button_path, String
      attribute :highlighted_content_banner_enabled, Boolean, default: false
      attribute :highlighted_content_banner_action_url, String
      attribute :highlighted_content_banner_image
      attribute :remove_highlighted_content_banner_image
      attribute :enable_omnipresent_banner, Boolean, default: false
      attribute :omnipresent_banner_url, String

      attribute :primary_color, String
      attribute :secondary_color, String
      attribute :success_color, String
      attribute :warning_color, String
      attribute :alert_color, String
      attribute :proposals_color, String
      attribute :actions_color, String
      attribute :debates_color, String
      attribute :meetings_color, String
      attribute :twitter_color, String
      attribute :facebook_color, String
      attribute :google_color, String

      translatable_attribute :cta_button_text, String
      translatable_attribute :description, String
      translatable_attribute :welcome_text, String
      translatable_attribute :highlighted_content_banner_title, String
      translatable_attribute :highlighted_content_banner_short_description, String
      translatable_attribute :highlighted_content_banner_action_title, String
      translatable_attribute :highlighted_content_banner_action_subtitle, String
      translatable_attribute :omnipresent_banner_title, String
      translatable_attribute :omnipresent_banner_short_description, String

      validates :cta_button_path, format: { with: %r{\A[a-zA-Z]+[a-zA-Z0-9\-\_/]+\z} }, allow_blank: true
      validates :official_img_header,
                :official_img_footer,
                :homepage_image,
                :logo,
                file_size: { less_than_or_equal_to: ->(_record) { Decidim.maximum_attachment_size } },
                file_content_type: { allow: ["image/jpeg", "image/png"] }

      validates :highlighted_content_banner_action_url, presence: true, if: :highlighted_content_banner_enabled?
      validates :highlighted_content_banner_image,
                presence: true,
                file_size: { less_than_or_equal_to: ->(_record) { Decidim.maximum_attachment_size } },
                file_content_type: { allow: ["image/jpeg", "image/png"] },
                if: :highlighted_content_banner_image_is_changed?

      validates :highlighted_content_banner_title,
                translatable_presence: true,
                if: :highlighted_content_banner_enabled?

      validates :highlighted_content_banner_short_description,
                translatable_presence: true,
                if: :highlighted_content_banner_enabled?

      validates :highlighted_content_banner_action_title,
                translatable_presence: true,
                if: :highlighted_content_banner_enabled?

      validates :omnipresent_banner_url, presence: true, if: :enable_omnipresent_banner?
      validates :omnipresent_banner_title, translatable_presence: true, if: :enable_omnipresent_banner?
      validates :omnipresent_banner_short_description, translatable_presence: true, if: :enable_omnipresent_banner?

      def map_model(model)
        model.custom_colors.tap do |colors|
          self.primary_color = colors["primary_color"]
          self.secondary_color = colors["secondary_color"]
          self.success_color = colors["success_color"]
          self.warning_color = colors["warning_color"]
          self.alert_color = colors["alert_color"]
          self.proposals_color = colors["proposals_color"]
          self.actions_color = colors["actions_color"]
          self.debates_color = colors["debates_color"]
          self.twitter_color = colors["twitter_color"]
          self.facebook_color = colors["facebook_color"]
          self.meetings_color = colors["meetings_color"]
          self.google_color = colors["google_color"]
        end
      end

      private

      def highlighted_content_banner_enabled?
        highlighted_content_banner_enabled
      end

      def enable_omnipresent_banner?
        enable_omnipresent_banner
      end

      def highlighted_content_banner_image_is_changed?
        highlighted_content_banner_enabled? &&
          current_organization.highlighted_content_banner_image.blank?
      end
    end
  end
end
