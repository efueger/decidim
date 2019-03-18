# frozen_string_literal: true

module Decidim
  module Admin
    # A command with all the business logic when a user unreports a resource.
    class MakeVisibleUpstreamResource < Rectify::Command
      # Public: Initializes the command.
      #
      # reportable - A Decidim::Reportable
      # current_user - the user performing the action
      def initialize(upstream_reportable, current_user)
        @upstream_reportable = upstream_reportable
        @current_user = current_user
      end

      # Executes the command. Broadcasts these events:
      #
      # - :ok when everything is valid, together with the resource.
      # - :invalid if the resource is not reported
      #
      # Returns nothing.
      def call
        return broadcast(:invalid) unless @upstream_reportable

        make_visible!

        notify_involved

        broadcast(:ok, @reportable)
      end

      private

      def make_visible!
        Decidim.traceability.perform_action!(
          "unreport",
          @upstream_reportable.upstream_moderation,
          @current_user,
          extra: {
            upstream_reportable_type: @upstream_reportable.class.name
          }
        ) do
          @upstream_reportable.upstream_moderation.update!(hidden_at: nil)
        end
      end

      def notify_involved
        if @upstream_reportable.class.name == "Decidim::Comments::Comment"
          parsed = Decidim::ContentProcessor.parse(@upstream_reportable.body, current_organization: upstream_reportable.component.organization)
          mentioned_users = parsed.metadata[:user].users
          Decidim::Comments::CommentCreation.publish(@upstream_reportable, parsed.metadata)
          send_notifications(mentioned_users)
        end
      end

      def send_notifications(mentioned_users)
        Decidim::Comments::NewCommentNotificationCreator.new(@upstream_reportable, mentioned_users).create
      end
    end
  end
end
