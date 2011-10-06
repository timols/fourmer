module Foursquare
  module Merchant

    class Special < Model
      property :count1
      property :count2
      property :count3
      property :description
      property :detail
      property :fine_print,           :from => :finePrint
      property :friends_here,         :from => :friendsHere
      property :icon
      property :id
      property :interaction
      property :message
      property :name
      property :progress
      property :progress_description, :from => :progressDescription
      property :provider
      property :redemption
      property :state
      property :status
      property :target
      property :text
      property :title
      property :type
      property :unlocked

      def retire
        self.post("/specials/#{id}/retire", {})
      end

      def configuration
        self.class.new(self.get("/specials/#{id}/configuration", {})['special'], @consumer)
      end
    end

  end
end
