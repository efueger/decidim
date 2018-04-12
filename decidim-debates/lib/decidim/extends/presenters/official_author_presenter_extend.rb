# frozen_string_literal: true
# This module is use to add customs methods to the original "OfficialAuthorPresenterExtend.rb"

module OfficialAuthorPresenterExtend
  def badges
    []
  end
end

Decidim::Debates::OfficialAuthorPresenter.class_eval do
  prepend(OfficialAuthorPresenterExtend)
end
