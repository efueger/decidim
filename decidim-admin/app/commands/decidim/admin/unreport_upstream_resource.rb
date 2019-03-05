# frozen_string_literal: true

module Decidim
  module Admin
    # A command with all the business logic when a user unreports a resource.
    class UnreportUpstreamResource < Rectify::Command
      # Public: Initializes the command.
      #
      # reportable - A Decidim::Reportable
      # current_user - the user performing the action
      def initialize(reportable, current_user)
        @reportable = reportable
        @current_user = current_user
      end

      # Executes the command. Broadcasts these events:
      #
      # - :ok when everything is valid, together with the resource.
      # - :invalid if the resource is not reported
      #
      # Returns nothing.
      def call
        return broadcast(:invalid) unless @reportable.reported?

        unreport!
        broadcast(:ok, @reportable)
      end

      private

      def unreport!
        Decidim.traceability.perform_action!(
          "unreport",
          @reportable.upstream_moderation,
          @current_user,
          extra: {
            reportable_type: @reportable.class.name
          }
        ) do
          @reportable.upstream_moderation.update!(report_count: 0, hidden_at: nil)
        end
      end
    end
  end
end
