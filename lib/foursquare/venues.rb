module Foursquare
  module Merchant

    class Venues < Base
      base_uri "#{API}/venues"

      def find(venue_id, params={})
        response = self.get("/#{venue_id}", params)
        Foursquare::Merchant::Venue.new(response['venue'], @consumer)
      end

      def managed(params={})
        response = self.get("/managed", params)
        venues = response['venues']
        venues.map { |item| Foursquare::Merchant::Venue.new(item, @consumer) }
      end

      def timeseries(venue_ids, start_at=nil, end_at=nil)
        params = {}
        params[:venue_id] = listify(venue_ids)
        params[:start_at] = start_at if start_at
        params[:end_at]   = end_at if end_at

        response = self.get("/timeseries", params)['timeseries']
        response.map { |ts| TimeSeries.new(ts) }
      end

      def search(params)
        raise "Must include lat/lng string" unless params.has_key? :ll
        response = self.get("/search", params)
        venues = response['groups'].map { |res| res['items'] }.flatten
        venues.map { |item| Foursquare::Merchant::Venue.new(item, @consumer) }
      end

    end

  end
end
