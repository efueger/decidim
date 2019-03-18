# frozen_string_literal: true

require "mustache"

module Decidim
  class UpstreamModeratedEvent < Decidim::Events::BaseEvent
    include Decidim::Events::EmailEvent
    include Decidim::Events::NotificationEvent
  end
end
