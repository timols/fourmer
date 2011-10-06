module Foursquare
  module Merchant

    class VenueGroups < Base
      base_uri "#{API}/venuegroups"

      def find(venue_group_id, params={})
        response = self.get("/#{venue_group_id}", params)
        Foursquare::Merchant::VenueGroup.new(response['venueGroup'], @consumer)
      end

      def add(params)
        response = self.post("/add", params)
        Foursquare::Merchant::VenueGroup.new(response['venueGroup'], @consumer)
      end
      
      def list(params={})
        response = self.get("/list", params)
        venue_groups = response['venueGroups']['items']
        venue_groups.map { |item| Foursquare::Merchant::VenueGroup.new(item, @consumer) }
      end

    end

  end
end
