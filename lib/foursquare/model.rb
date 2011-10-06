module Foursquare
  module Merchant

    class Model < Hashie::Trash
      include HTTParty
      include Merchant::Requests

      base_uri Merchant::Requests::API
      format :json

      attr_reader :consumer
      def initialize(hash, consumer)
        @consumer = consumer
        super(hash)
      end

      private
        def listify(venues)
          case venues
          when Array
            venues.join(',')
          when String
            venues
          else
            raise ArgumentError, "Please ensure you're attempting to use either an " +
                                 "array of venue ids, or a comma delimited list of ids"
          end
        end

    end
  end
end