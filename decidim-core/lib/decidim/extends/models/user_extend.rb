module UserExtend
  def eid_verified?
    true
  end
end

Decidim::User.class_eval do
  prepend(UserExtend)
end
