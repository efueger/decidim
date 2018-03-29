module UserPresenterExtend
  def badge
    badges = []

    if officialized?
      badges << "verified-badge"
    end

    if eid_verified?
      badges << "eid-verified"
    end

    badges
  end
end

Decidim::UserPresenter.class_eval do
  prepend(UserPresenterExtend)
end
