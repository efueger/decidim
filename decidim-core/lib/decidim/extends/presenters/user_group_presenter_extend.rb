module UserGroupPresenterExtend
  def badge
    badges = []

    if verified?
      badges << "verified-badge"
    end

    if eid_verified?
      badges << "eid-verified"
    end

    badges
  end
end

Decidim::UserGroupPresenter.class_eval do
  prepend(UserGroupPresenterExtend)
end
