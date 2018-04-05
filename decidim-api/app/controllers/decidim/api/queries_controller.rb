# frozen_string_literal: true

module Decidim
  module Api
    # This controller takes queries from an HTTP endpoint and sends them out to
    # the Schema to be executed, later returning the response as JSON.
    class QueriesController < Api::ApplicationController
      skip_authorization_check
      around_action :store_current_user

      def traduction

        # https://api.deepl.com/v1/translate
        # /v1/translate?text=Hallo%20Welt!&target_lang=EN&auth_key=123
        # { "translations": [ { "detected_source_language": "DE", "text": "Hello World!" } ] }
        
        auth_key = "e4661e18-b983-08df-6335-d19ad787fed6"
        uri = URI.parse("https://api.deepl.com/v1/translate?text=#{params[:original]}&target_lang=FR&auth_key=#{auth_key}")
        request = Net::HTTP::Get.new(uri)
        request.content_type = "application/json"
        req_options = {
           use_ssl: uri.scheme == "https",
        }
        response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
          my_req = http.request(request)
          my_hash = JSON.parse(my_req.body)
          puts my_hash
          render json: my_hash
        end
      end

      def create
        query_string = params[:query]
        query_variables = ensure_hash(params[:variables])
        result = Schema.execute(query_string, variables: query_variables, context: context)
        render json: result
      end

      private

      def context
        {
          current_organization: current_organization,
          current_user: current_user
        }
      end

      def ensure_hash(query_variables)
        if query_variables.blank?
          {}
        elsif query_variables.is_a?(String)
          JSON.parse(query_variables)
        else
          query_variables
        end
      end

      def store_current_user
        Thread.current[:current_user] = current_user
        yield
        ensure
        Thread.current[:current_user] = nil
      end
    end
  end
end
