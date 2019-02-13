# frozen_string_literal: true

require "spec_helper"
require "support/tasks"

describe "rake decidim:reminder:budgets_order", type: :task do
  let(:order) { create(:order) }

  it "notifies user" do
    expect(Decidim::EventsManager)
      .to receive(:publish)
            .with(
              event: "decidim.events.budgets.unfinished_order",
              event_class: Decidim::Budgets::UnfinishedOrderEvent,
              resource: order.component,
              affected_users: [order.user]
            )

    subject.call
  end
end
