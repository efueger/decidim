# frozen_string_literal: true

module Decidim
  module Api
    # This controller takes queries from an HTTP endpoint and sends them out to
    # the Schema to be executed, later returning the response as JSON.
    class QueriesController < Api::ApplicationController
      skip_authorization_check
      around_action :store_current_user

      def traduction
        auth_key = "5a759d84-bab3-6b62-073e-ef367ff8e3f9" # DEEPL_API_KEY="your_api_key" rails s 
        puts "AUTH KEY : #{auth_key}"
        target_lang = params[:target]
        original_txt = URI.encode(params[:original])
        uri = URI.parse("https://api.deepl.com/v1/translate?text=#{original_txt}&target_lang=#{target_lang}&auth_key=#{auth_key}")
        request = Net::HTTP::Get.new(uri)
        request.content_type = "application/json"
        req_options = {
           use_ssl: uri.scheme == "https",
        }
        response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
          my_req = http.request(request)
          my_hash = JSON.parse(my_req.body)
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
