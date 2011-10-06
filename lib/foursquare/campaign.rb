module Foursquare
  module Merchant

    class Campaign < Model
      property :venue_group_ids,  :from => :venueGroupIds
      property :starts_at,        :from => :startsAt
      property :ends_at,          :from => :endsAt
      property :venue_ids,        :from => :venues
      property :special_id,       :from => :specialId
      property :venue_groups,     :from => :venueGroups
      property :id
      property :special

      def initialize(hash, consumer)
        super
        self.venue_ids       = self.venue_ids['items'].map { |item| item['id'] } if self.venue_ids
        self.venue_group_ids = self.venue_group_ids['items'].map { |item| item['id'] } if self.venue_group_ids
        self.venue_groups    = self.venue_groups['items'].map { |item| item['id'] } if self.venue_groups
        self.special         = Special.new(self.special, consumer) if self.special
      end

      def timeseries(start_time=nil, end_time=nil)
        params = {}
        params[:start_at] = start_time if start_time
        params[:end_at]   = end_time if end_time

        response = self.get("/campaigns/#{id}/timeseries", params)['timeseries']
        response.map { |ts| TimeSeries.new(ts) }
      end

      def start(start_time=nil)
        params = {}
        params[:start_at] = start_time if start_time
        self.post("/campaigns/#{id}/start", params)
      end

      def end(end_time=nil)
        params = {}
        params[:end_at] = end_time if end_time
        self.post("/campaigns/#{id}/start", params)
      end

      def delete
        self.post("/campaigns/#{id}/delete", {})
      end
    end

  end
end
