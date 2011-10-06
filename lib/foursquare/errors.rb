module Foursquare
  module Merchant
    module Errors
      class APIError < StandardError; end
      class OAuthError < APIError; end

      # Dynamically create errors from responses we receive from the
      # Foursquare Merchant API
      def self.new(type, message=nil)
        unless self.const_defined?(type)
          self.const_set type.intern, Class.new(APIError) do
            attr_reader :message

            def initialize(message=nil)
              @message = message
            end
          end
        end

        self.const_get(type).new(message)
      end
    end
  end
end