# frozen_string_literal: true

class AddFieldsToDecidimOrganization < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_organizations, :primary_color, :string
    add_column :decidim_organizations, :secondary_color, :string

    add_column :decidim_organizations, :success_color, :string
    add_column :decidim_organizations, :warning_color, :string
    add_column :decidim_organizations, :alert_color, :string

    add_column :decidim_organizations, :proposals_color, :string
    add_column :decidim_organizations, :actions_color, :string
    add_column :decidim_organizations, :debates_color, :string
    add_column :decidim_organizations, :meetings_color, :string

    add_column :decidim_organizations, :twitter_color, :string
    add_column :decidim_organizations, :facebook_color, :string
    add_column :decidim_organizations, :google_color, :string
  end
end
