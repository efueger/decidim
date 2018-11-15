# frozen_string_literal: true

module Decidim
  module CustomColorsHelper
    def darken(color, percent)
      red = color[1..2].to_i(16) * percent_to_ratio(percent)
      green = color[3..4].to_i(16) * percent_to_ratio(percent)
      blue = color[5..6].to_i(16) * percent_to_ratio(percent)
      "rgb(#{red.round}, #{green.round}, #{blue.round})"
    end

    private

    def percent_to_ratio(percent)
      1 - percent * 2.0 / 100
    end
  end
end
