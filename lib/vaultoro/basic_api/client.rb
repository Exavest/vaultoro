require 'openssl'
require 'net/http'
require 'net/https'
require 'json'

module Vaultoro
  module BasicAPI
    class Client
      def self.get(endpoint, params = {})
        begin
          uri = URI.parse([Vaultoro.api_uri, endpoint].join)
          uri.query = URI.encode_www_form(params)
          http = Net::HTTP.new(uri.host, uri.port)
          http.use_ssl = uri.scheme == 'https'
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE
          request = Net::HTTP::Get.new(uri, headers)
          response = http.request(request)
        rescue StandardError => error
          puts "Request failed (#{error.message})"
        end
      end

      def self.post(endpoint, params = {})
        begin
          uri = URI.parse([Vaultoro.api_uri, endpoint].join)
          uri.query = URI.encode_www_form(params)
          # body = URI.encode_www_form(params)
          http = Net::HTTP.new(uri.host, uri.port)
          http.use_ssl = uri.scheme == 'https'
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE
          request = Net::HTTP::Post.new(uri, headers)
          request.add_field "Content-Type", "application/x-www-form-urlencoded"
          # request.body = body
          response = http.request(request)
        rescue StandardError => error
          puts "Request failed (#{error.message})"
        end
      end

      private

      def headers
        { 'User-Agent' => Vaultoro::VERSION::SUMMARY, 'Accept' => 'application/json' }
      end
    end
  end
end
