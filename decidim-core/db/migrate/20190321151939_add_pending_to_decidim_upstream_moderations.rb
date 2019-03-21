class AddPendingToDecidimUpstreamModerations < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_upstream_moderations, :pending, :boolean, default: true
  end
end
