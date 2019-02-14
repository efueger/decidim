# frozen_string_literal: true

module Decidim
  module Budgets
    class UnfinishedOrderReminderJob < ApplicationJob
      queue_as :reminder

      def perform(unfinished_order_id)
        order = Decidim::Budgets::Order.find(unfinished_order_id)
        send_notification(order) unless order.checked_out?
      end

      private

      def send_notification(resource)
        Decidim::EventsManager.publish(
          event: "decidim.events.budgets.unfinished_order",
          event_class: Decidim::Budgets::UnfinishedOrderEvent,
          resource: resource.component,
          affected_users: [resource.user]
        )
      end
    end
  end
end
