module Foursquare
  module Merchant

    class Specials < Base
      base_uri "#{API}/specials"

      def find(special_id, params={})
        response = self.get("/#{special_id}", params)
        Foursquare::Merchant::Special.new(response['special'], @consumer)
      end

      def add(params)
        response = self.post("/add", params)
        Foursquare::Merchant::Special.new(response['special'], @consumer)
      end
      
      def list(params={})
        response = self.get("/list", params)
        specials = response['specials']['items']
        specials.map { |item| Foursquare::Merchant::Special.new(item, @consumer) }
      end

      def search(params)
        raise "Must include lat/lng string" unless params.has_key? :ll
        response = self.get("/search", params)
        specials = response['specials']['items']
        specials.map { |item| Foursquare::Merchant::Special.new(item, @consumer) }
      end

    end

  end
end
