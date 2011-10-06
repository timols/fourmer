require File.expand_path('../helper', __FILE__)

class TestVenueGroups < Test::Unit::TestCase
  def setup
    @consumer = Foursquare::Merchant::Consumer.new('TOKEN')
  end

  def test_initialize
    venue_groups_proxy = Foursquare::Merchant::VenueGroups.new(@consumer)
    assert_instance_of(Foursquare::Merchant::VenueGroups, venue_groups_proxy)
  end

  def test_find
    response = stub(:parsed_response => {
      'meta' => {'code' => 200},
      'response' => {'venueGroup' => {'id' => 'abcdef'}}
      }
    )
    Foursquare::Merchant::VenueGroups.stubs(:get).returns(response)
    assert_equal('abcdef', @consumer.venue_groups.find('abcdef').id)
  end

  def test_add
    response = stub(:parsed_response => {
      'meta' => {'code' => 200},
      'response' => {'venueGroup' => {'id' => 'abcdef'}}
      }
    )
    Foursquare::Merchant::VenueGroups.stubs(:post).returns(response)
    assert_equal('abcdef', @consumer.venue_groups.add('abcdef').id)
  end

  def test_list
    items = [{'id' => 'abcdef'}, {'id' => 'fedcba'}]
    response = stub(:parsed_response => {
      'meta' => {'code' => 200},
      'response' => {'venueGroups' => {'count' => 2, 'items' => items}}
      }
    )
    Foursquare::Merchant::VenueGroups.stubs(:get).returns(response)
    venue_groups = [Foursquare::Merchant::VenueGroup.new(items[0], @consumer),
                    Foursquare::Merchant::VenueGroup.new(items[1], @consumer)]

    assert_equal(venue_groups, @consumer.venue_groups.list)
  end

end
