module UserGroupPresenterExtend
  def badges
    return [] unless verified?

    ["verified-badge"] # return as an array because sometimes there are multiple badges and we should be able to loop on it.
  end
end

Decidim::UserGroupPresenter.class_eval do
  prepend(UserGroupPresenterExtend)
end
