class AddCustomColorsToDecidimOrganization < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_organizations, :custom_colors, :jsonb
  end
end
