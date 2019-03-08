# frozen_string_literal: true

require "active_support/concern"

module Decidim
  # A concern with the components needed when you want a model to be reportable
  module UpstreamReportable
    extend ActiveSupport::Concern

    included do
      has_one :upstream_moderation, as: :upstream_reportable, foreign_key: "decidim_upstream_reportable_id", foreign_type: "decidim_upstream_reportable_type", class_name: "Decidim::UpstreamModeration"

      scope :visible, -> { left_outer_joins(:upstream_moderation).where(Decidim::UpstreamModeration.arel_table[:hidden_at].eq nil) }
      scope :not_visible, -> { left_outer_joins(:upstream_moderation).where.not(Decidim::UpstreamModeration.arel_table[:hidden_at].eq nil) }

      def add_to_upstream_moderation
        return unless upstream_moderation_activated?

        Decidim::UpstreamModeration.find_or_create_by!(
          upstream_reportable: self,
          participatory_space: participatory_space
        ).update!(hidden_at: Time.now)
      end

      def upstream_moderation_activated?
        component.settings.upstream_moderation
      end

      # Public: Checks if the reportable is hidden or not.
      #
      # Returns Boolean.
      def visible?
        upstream_moderation&.hidden_at&.present?
      end

      # Public: The reported content url
      #
      # Returns String
      def reported_content_url
        raise NotImplementedError
      end
    end
  end
end
