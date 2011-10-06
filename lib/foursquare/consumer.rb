module Foursquare
  module Merchant

    class Consumer < Base
      base_uri Merchant::Requests::OAUTH

      attr_reader :oauth_token, :client_id, :client_secret
      def initialize(*args)
        if args.size == 1
          @oauth_token = args.first
        elsif args.size == 2
          @client_id, @client_secret = args
        else
          raise ArgumentError, "Please include either an access token or client id & secret"
        end
      end

      def authorize_url(callback_url)
        raise ArgumentError.new("Please use a valid client_id") unless @client_id
        if callback_url =~ /http/
          query = {
            :client_id => @client_id,
            :response_type => 'code',
            :redirect_uri => callback_url
          }.map { |k,v| "#{k}=#{v}"}.join('&')
          "#{OAUTH}/authenticate?#{query}"
        else
          raise ArgumentError, "Please ensure you specify a valid callback url, including the protocol (http://)"
        end
      end

      def access_token(code, callback_url)
        raise "Please ensure you've defined the client_id" if @client_id.nil?
        raise "Please ensure you've defined the client_secret" if @client_secret.nil?
        raise "No code was provided" if code.nil?
        raise "Invalid callback url" if (callback_url.nil? or callback_url.scan(/http\:\/\//).empty?)

        query = {
          :client_id => @client_id,
          :client_secret => @client_secret,
          :grant_type => 'authorization_code',
          :redirect_uri => callback_url,
          :code => code
        }
        request = self.class.get("/access_token", {:query => query})
        if request.code == 200
          request.parsed_response['access_token']
        else
          raise Errors::OAuthError, request.parsed_response['error']
        end
      end

      %w(campaigns specials venue_groups venues).each do |endpoint|
        define_method "#{endpoint}" do
          elem = camel_case(endpoint)
          Foursquare::Merchant.module_eval("#{elem}").new(self)
        end
      end
    end

  end
end