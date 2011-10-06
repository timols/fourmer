module Foursquare
  module Merchant

    class Campaigns < Base
      base_uri "#{API}/campaigns"

      def find(campaign_id, params={})
        response = self.get("/#{campaign_id}", params)
        Foursquare::Merchant::Campaign.new(response['campaign'], @consumer)
      end

      def add(params)
        response = self.post("/add", params)
        Foursquare::Merchant::Campaign.new(response['campaign'], @consumer)
      end

      def list(params={})
        response = self.get("/list", params)
        campaigns = response['campaigns']['items']
        campaigns.map { |item| Foursquare::Merchant::Campaign.new(item, @consumer) }
      end
    end

  end
end
