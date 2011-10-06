module Foursquare
  module Merchant

    class VenueGroup < Model
      property :id
      property :name
      property :venues

      def initialize(hash, consumer)
        super
        self.venues = self.venues['items'].map { |item| Venue.new(item, @consumer) } if self.venues
      end

      def delete
        self.post("venuegroups/#{id}/delete", {})
      end

      def add_venue(venue_ids)
        params = {:venue_ids => listify(venue_ids)}
        self.post("venuegroups/#{id}/addvenue", params)
      end

      def remove_venue(venue_ids)
        params = {:venue_ids => listify(venue_ids)}
        self.post("venuegroups/#{id}/removevenue", params)
      end

    end

  end
end
