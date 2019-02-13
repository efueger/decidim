# frozen_string_literal: true

require "spec_helper"

describe Decidim::Budgets::UnfinishedOrderEvent do
  let(:event_name) { "decidim.events.budgets.unfinished_order" }
  let(:order) { create(:order) }
  let(:resource) { order.component }

  include_context "when a simple event"
  it_behaves_like "a simple event"
end
