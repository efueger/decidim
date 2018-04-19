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

    def badge
      return "" unless verified?

      "verified-badge"
    end

    def badges
      return [] unless verified?

      ["verified-badge"] # return as an array because sometimes there are multiple badges and we should be able to loop on it.
    end

    def profile_path
      ""
    end

    delegate :url, to: :avatar, prefix: true
  end
end
