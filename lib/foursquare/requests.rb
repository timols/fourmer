module Foursquare
  module Merchant

    module Requests
      API = 'https://api.foursquare.com/v2'
      OAUTH = 'https://foursquare.com/oauth2'

      def get(path, params)
        request = self.class.get(path, {:query => camelize(params).merge(auth_params)})
        handle_response(request)
      end

      def post(path, params)
        request = self.class.post(path, {:body => camelize(params).merge(auth_params)})
        handle_response(request)
      end

      private
        def camel_case(string, capital=true)
          elem = capital == true ? string.capitalize : string
          elem.gsub(/(_[a-z])/) { |match| match[1..1].upcase }
        end

        def camelize(params)
          params.inject({}) { |o, (k, v)| o[camel_case(k.to_s, false)] = v; o}
        end

        def auth_params
          if @consumer.oauth_token
            {:oauth_token => @consumer.oauth_token }
          else
            {:client_id => @consumer.client_id, :client_secret => @consumer.client_secret }
          end
        end

        def handle_response(request)
          response = request.parsed_response
          meta = response['meta']

          if meta['code'] != 200
            type, message = camel_case(meta['errorType']), meta['errorDetail']
            raise Merchant::Errors.new(type, message)
          end

          response['response']
        end
    end
  end
end