# frozen_string_literal: true

require "spec_helper"

describe Decidim::Budgets::UnfinishedOrderReminderJob do
  subject { described_class }

  describe "queue" do
    it "is queued to reminder" do
      expect(subject.queue_name).to eq "reminder"
    end
  end

  describe "perform" do
    # TODO: CLEAN UP THIS MESS
    let!(:order) { create(:order) }

    it "sends a reminder email" do
      subject.perform_now(order.id)

      expect(Decidim::EventsManager)
        .to receive(:publish)
              .with(
                event: "decidim.events.budgets.unfinished_order",
                event_class: Decidim::Budgets::UnfinishedOrderEvent,
                resource: order.component,
                affected_users: [order.user]
              )
    end

    context "when order has been checkout out" do
      it "doesn't sends a reminder email" do
        order.checked_out_at = Time.now - 1.day
        order.save

        subject.perform_now(order.id)

        expect(Decidim::EventsManager)
          .not_to receive(:publish)
      end
    end
  end
end
