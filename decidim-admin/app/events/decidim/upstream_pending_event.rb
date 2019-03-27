# frozen_string_literal: true

require "mustache"

module Decidim
  class UpstreamPendingEvent < Decidim::Events::SimpleEvent
    include Decidim::Events::AuthorEvent

    # Caches the path for the given resource when it's a Decidim::Component.
    def resource_path
      return super unless resource.is_a?(Decidim::Comments::Comment)

      @resource_path ||= Decidim::ResourceLocatorPresenter.new(resource.root_commentable).path(url_params)
    end

    # Caches the URL for the given resource when it's a Decidim::Component.
    def resource_url
      return super unless resource.is_a?(Decidim::Comments::Comment)

      @resource_url ||= Decidim::ResourceLocatorPresenter.new(resource.root_commentable).url(url_params)
    end

    def resource_title
      return super unless resource.is_a?(Decidim::Comments::Comment)

      if resource.root_commentable.respond_to?(:title)
        translated_attribute(resource.root_commentable.title)
      elsif resource.root_commentable.respond_to?(:name)
        translated_attribute(resource.root_commentable.name)
      end
    end

    def url_params
      { anchor: "comment_#{resource.id}" }
    end
  end
end
