module Foursquare
  module Merchant

    class Venue < Model
      property :been_here,      :from => :beenHere
      property :canonical_url,  :from => :canonicalUrl
      property :categories
      property :contact
      property :created_at,     :from => :createdAt
      property :description
      property :here_now,       :from => :hereNow
      property :id
      property :listed
      property :location
      property :mayor
      property :name
      property :photos
      property :short_url,      :from => :shortUrl
      property :specials
      property :stats
      property :tags
      property :time_zone,      :from => :timeZone
      property :tips
      property :todos
      property :url
      property :verified

      def fetch
        response = self.get("/venues/#{id}", {})['venue']
        self.class.new(response, @consumer)
      end

      def stats(start_at=nil, end_at=nil)
        params = {}
        params[:start_at] = start_at if start_at
        params[:end_at]   = end_at if end_at

        response = self.get("/venues/#{id}/stats", params)['stats']
        VenueStats.new(response)
      end

      def edit(params)
        response = self.post("/venues/#{id}/edit", params)['venue']
        temp_venue = self.fetch
        temp_venue.keys.each { |k| self.send("#{k}=", temp_venue.send("#{k}")) }
        self
      end

    end

  end
end
