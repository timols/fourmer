# fourmer

fourmer is an unofficial wrapper for the [Foursquare Merchant API](https://developer.foursquare.com/merchant/).

fourmer makes it easy for you to create new campaigns, specials and venue groups for the venues you manage.

## Installation

Fourmer is distributed as a gem, which is how it should be used in your app. Assuming you have rubygems or bundler, simply do the following:

    gem install fourmer

Or include the gem in your Gemfile.

    gem "fourmer", ">= 0"

## Usage

Fourmer is designed to be as simple to use as possible, to mimic the layout and actions available in the Foursquare Merchant API.

### Web Applications

Initialize your consumer with userless access:

    merchant = Foursquare::Merchant::Consumer.new('CLIENT_ID', 'CLIENT_SECRET')

Redirect users to the Foursquare authentication page:

    # If using Rails:
    redirect_to merchant.authorize_url('YOUR_CALLBACK_URL')
    
    # Otherwise, redirect your users to:
    merchant.authorize_url('YOUR_CALLBACK_URL')

The user will then be asked whether to authorize your application. If the user accepts, then Foursquare will redirect the user to your callback url (`YOUR_CALLBACK_URL`) with a `code` in the url. You then exchange this `code` for an access token:

    access_token = merchant.access_token(params[:code], 'YOUR_CALLBACK_URL')

You can then make requests on the user's behalf by re-initializing your consumer:

    merchant = Foursquare::Merchant::Consumer.new(access_token)

For a description of the Foursquare Authentication flow, go [here](https://developer.foursquare.com/merchant/oauth.html).

### Quick Start

Initialize your consumer:

    merchant = Foursquare::Merchant::Base.new('ACCESS_TOKEN')

Or for userless access (only works for some objects and actions, such as venue search):

    merchant = Foursquare::Merchant::Base.new('CLIENT_ID', 'CLIENT_SECRET')

#### Campaigns

Find an existing campaign:

    campaign = merchant.campaigns.find('campaign_id')
    #=> #<Foursquare::Merchant::Campaign: ...>

Delete an existing campaign that has never been activated:

    campaign.delete
    #=> nil

#### Specials

Get a list of all specials for the current user:

    specials = merchant.specials.list
    #=> [#<Foursquare::Merchant::Special: ...>, ...]

Create a new special:

    params = { 'text' => 'Some text', 'unlockedText' => 'Some other text', ... }
    special = merchant.specials.add(params)
    #=> #<Foursquare::Merchant::Special: ...>

#### Venuegroups

Create a new venue group:

    venuegroup = merchant.venue_groups.add('NAME_OF_VENUEGROUP')
    #=> #<Foursquare::Merchant::Venuegroup: ...>
    
Add venues to it:

    venues = [#<Foursquare::Merchant::Venue: ...>, ...]
    venuegroup.addvenue(venues)
    #=> nil

Note that venues can either be a single venue id string/venue object, an array of venue ids, or an array of venue objects.

#### Venues

Get a list of all of the venues managed by the user:

    managed_venues = merchant.venues.managed
    #=> [#<Foursquare::Merchant::Venue: ...>, ...]

Edit a venue managed by the user:

    venue = merchant.venues.find('VENUE_ID')
    venue.update({'url' => 'http://some.domain.com/'})
    #=> #<Foursquare::Merchant::Venue: ...>

See the [Foursquare Merchant API](https://developer.foursquare.com/merchant/) for further actions available for campaigns, specials, venuegroups and venues.

## Contributing to fourmer
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2011 Tim Olshansky. See LICENSE.txt for
further details.

