module UserGroupExtend
  def eid_verified?
    true
  end
end

Decidim::UserGroup.class_eval do
  prepend(UserGroupExtend)
end
