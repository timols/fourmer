module Foursquare
  module Merchant

    class TimeSeries < Hashie::Trash
      property :venue_id,         :from => :venueId,        :required => true
      property :total_checkins,   :from => :totalCheckins
      property :new_checkins,     :from => :newCheckins
      property :viewing_users,    :from => :viewingUsers
      property :unlocking_users,  :from => :unlockingUsers
    end

  end
end
