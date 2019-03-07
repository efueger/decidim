# frozen_string_literal: true

module Decidim
  # A moderation belongs to a reportable and includes many reports
  class UpstreamModeration < ApplicationRecord
    include Traceable
    include Loggable

    belongs_to :upstream_reportable, foreign_key: "decidim_upstream_reportable_id", foreign_type: "decidim_upstream_reportable_type", polymorphic: true
    belongs_to :participatory_space, foreign_key: "decidim_participatory_space_id", foreign_type: "decidim_participatory_space_type", polymorphic: true

    delegate :component, :organization, to: :reportable

    def self.log_presenter_class_for(_log)
      Decidim::AdminLog::UpstreamModerationPresenter
    end
  end
end
