# frozen_string_literal: true

class AddSingleDateToDecidimParticipatoryProcessSteps < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_participatory_process_steps, :single_date, :boolean, null: false, default: false
  end
end
