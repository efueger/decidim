# frozen_string_literal: true

namespace :decidim do
  namespace :reminder do
    desc "Send notification to users with unfinished order"
    task budgets_order: :environment do
      unfinished_orders = Decidim::Budgets::Order.where(checked_out_at: nil).where("updated_at <= ?", Time.now - 1.hour)

      Rails.logger.info("=============")
      Rails.logger.info("Sending #{unfinished_orders.count} notifications to users with unfinished order")
      Rails.logger.info("=============")

      unfinished_orders.each do |unfinished_order|
        Decidim::Budgets::UnfinishedOrderReminderJob.perform_later(unfinished_order.id)
      end
    end
  end
end
