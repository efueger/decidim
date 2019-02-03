# frozen_string_literal: true

module Decidim
  # A middleware that enhances the request with the current organization based
  # on the hostname.
  class CurrentOrganization
    # Initializes the Rack Middleware.
    #
    # app - The Rack application
    def initialize(app)
      @app = app
    end

    # Main entry point for a Rack Middleware.
    #
    # env - A Hash.
    def call(env)
      organization = detect_current_organization(env)
      if organization
        env["decidim.current_organization"] = organization
        @app.call(env)
      else
        organization = find_secondary_host_org(env)
        return @app.call(env) unless organization

        participatory_space = detect_current_participatory_space(env)

        if participatory_space
          env["decidim.current_organization"] = organization
          env["decidim.current_participatory_space"] = participatory_space
          env["decidim.is_direct_participatory_space"] = true
          @app.call(env)
        else
          location = new_location_for(env, organization.host)
          [301, { "Location" => location, "Content-Type" => "text/html", "Content-Length" => "0" }, []]
        end
      end
    end

    private

    def detect_current_organization(env)
      Decidim::Organization.find_by(host: host_for(env))
    end

    def detect_current_participatory_space(env)
      Decidim::Assembly.find_by(hostname: host_for(env))
    end

    def find_secondary_host_org(env)
      Decidim::Organization.find_by("? = ANY(secondary_hosts)", host_for(env))
    end

    def host_for(env)
      @host ||= Rack::Request.new(env).host.downcase
    end

    def new_location_for(env, host)
      request = Rack::Request.new(env)
      url = URI(request.url)
      url.host = host
      url.to_s
    end
  end
end
