# frozen_string_literal: true

module Decidim
  #
  # Decorator for user groups
  #
  class UserGroupPresenter < SimpleDelegator
    def nickname
      ""
    end

    def deleted?
      false
    end

    def badge # This method has been extended in lib/decidim/extends/presenters/user_group_presenter_extend.rb
      return "" unless verified?

      "verified-badge"
    end

    def profile_path
      ""
    end

    delegate :url, to: :avatar, prefix: true
  end
end
