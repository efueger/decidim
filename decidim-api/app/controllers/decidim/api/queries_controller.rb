# frozen_string_literal: true

module Decidim
  module Api
    # This controller takes queries from an HTTP endpoint and sends them out to
    # the Schema to be executed, later returning the response as JSON.
    class QueriesController < Api::ApplicationController
      skip_authorization_check
      around_action :store_current_user

      def traduction
        render json: translate(params[:original], params[:target])
      end

      def create
        query_string = params[:query]
        query_variables = ensure_hash(params[:variables])
        result = Schema.execute(query_string, variables: query_variables, context: context)
        render json: result
      end

      private

      def trad_api_request(uri)
        request = Net::HTTP::Get.new(uri)
        request.content_type = "application/json"
        req_options = {
           use_ssl: uri.scheme == "https",
        }
        response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
          my_req = http.request(request)
          my_hash = JSON.parse(my_req.body)
          return my_hash
        end
      end

      def traduire(text, target_lang) 
        auth_key = ENV['DEEPL_API_KEY']
        encode_text = URI.encode(text)
        uri = URI.parse("https://api.deepl.com/v1/translate?text=#{encode_text}&target_lang=#{target_lang}&auth_key=#{auth_key}")
        result = trad_api_request(uri)
        return result
      end

      def parse_by_p(html)
        document = Nokogiri::HTML(html).search("p")
        parsed_by_p = document.to_s.gsub("<p>", "").split("</p>")
        return (parsed_by_p)
      end

      def get_ready_for_threads(parsed_html)
        thread_list = []
        parsed_html.each do |p|
          if p.strip.empty? == false
            thread_list << {text: p, ret: ""}
          end
        end
        return thread_list
      end

      def get_text_from_threads(traducted_threads)
        final_text = "".dup
        traducted_threads.each do |p|
          final_text << "<p>#{p[:ret]["translations"][0]["text"]}</p>"
        end
        return final_text
      end

      def get_average_language(traducted_threads, target_lang)
        arr = []
        traducted_threads.each do |i|
          arr << i[:ret]["translations"][0]["detected_source_language"]
        end
        freq = arr.inject(Hash.new(0)) { |h,v| h[v] += 1; h }
        average_language = arr.max_by { |v| freq[v] }
        if average_language == ""
          return target_lang
        end
        return average_language
      end


      def translate(text, target_lang)
        html = text
        parsed_by_p = parse_by_p(html)
        threads_food = get_ready_for_threads(parsed_by_p)
        threads = []
        threads_food.each do |p|
            threads << Thread.new do
              p[:ret] = traduire(p[:text], target_lang)
            end
        end
        threads.each { |thr| thr.join }
        average_language = get_average_language(threads_food, target_lang)
        final_text = get_text_from_threads(threads_food)
        return {translations: [{detected_source_language: average_language, text: final_text}]}
      end

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
