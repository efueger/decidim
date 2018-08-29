# frozen_string_literal: true

module Decidim
  module ParticipatoryProcesses
    # Helpers related to the Participatory Process layout.
    module ParticipatoryProcessHelper
      # Public: Returns the dates for a step in a readable format like
      # "2016-01-01 - 2016-02-05".
      #
      # participatory_process_step - The step to format to
      #
      # Returns a String with the formatted dates.
      def step_dates(participatory_process_step)
        if participatory_process_step.single_date
          localize(participatory_process_step.start_date.to_date, format: :default)
        else
          dates = [participatory_process_step.start_date, participatory_process_step.end_date]
          dates.map { |date| date ? localize(date.to_date, format: :default) : "?" }.join(" - ")
        end
      end
    end
  end
end
