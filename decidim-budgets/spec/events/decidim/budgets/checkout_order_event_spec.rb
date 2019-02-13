# frozen_string_literal: true

require "spec_helper"

describe Decidim::Budgets::CheckoutOrderEvent do
  let(:order) { create :order }
  let(:resource) { order.component }
  let(:event_name) { "decidim.events.budgets.order_checkout" }

  include_context "when a simple event"
  it_behaves_like "a simple event"

  describe "email_subject" do
    it "is generated correctly" do
      expect(subject.email_subject).to eq("Your vote has been validated")
    end
  end

  describe "email_intro" do
    it "is generated correctly" do
      expect(subject.email_intro)
        .to eq("Your vote has been validated. You can always edit it if you like by clicking here:")
    end
  end

  describe "email_outro" do
    it "is generated correctly" do
      expect(subject.email_outro)
        .to eq("Thank you for your participation")
    end
  end

  describe "notification_title" do
    it "is generated correctly" do
      expect(subject.notification_title)
        .to eq("Your vote has been validated")
    end
  end
end
