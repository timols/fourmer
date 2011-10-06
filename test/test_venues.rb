require File.expand_path('../helper', __FILE__)

class TestVenues < Test::Unit::TestCase
  def setup
    @consumer = Foursquare::Merchant::Consumer.new('TOKEN')
  end

  def test_initialize
    venues_proxy = Foursquare::Merchant::Venues.new(@consumer)
    assert_instance_of(Foursquare::Merchant::Venues, venues_proxy)
  end

  def test_find
    response = stub(:parsed_response => {
      'meta' => {'code' => 200},
      'response' => {'venue' => {'id' => 'abcdef'}}
      }
    )
    Foursquare::Merchant::Venues.stubs(:get).returns(response)
    assert_equal('abcdef', @consumer.venues.find('abcdef').id)
  end

  def test_managed
    response = stub(:parsed_response => {
      'meta' => {'code' => 200},
      'response' => {'venues' => [{'id' => 'abcdef'}]}
      }
    )
    venue = Foursquare::Merchant::Venue.new({'id' => 'abcdef'}, @consumer)
    Foursquare::Merchant::Venues.stubs(:get).returns(response)
    assert_equal([venue], @consumer.venues.managed)
  end

  def test_timeseries
    response = stub(:parsed_response => {
      'meta' => {'code' => 200},
      'response' => {'timeseries' => [{'venueId' => 'abcdef'}]}
      }
    )
    ts = Foursquare::Merchant::TimeSeries.new({:venueId => 'abcdef'})
    Foursquare::Merchant::Venues.stubs(:get).returns(response)
    assert_equal([ts], @consumer.venues.timeseries('abcdef'))
  end

  def test_search_no_lat_long
    response = stub(:parsed_response => {
      'meta' => {'code' => 200},
      'response' => {'venues' => [{'id' => 'abcdef'}]}
      }
    )
    Foursquare::Merchant::Venues.stubs(:get).returns(response)
    assert_raise(RuntimeError) { @consumer.venues.search({}) }
  end

  def test_search_with_lat_long
    response = stub(:parsed_response => {
      'meta' => {'code' => 200},
      'response' => {'groups' => [{'items' => [{'id' => 'abcdef'}]}]}
      }
    )
    venue = Foursquare::Merchant::Venue.new({'id' => 'abcdef'}, @consumer)
    Foursquare::Merchant::Venues.stubs(:get).returns(response)
    assert_equal([venue], @consumer.venues.search({:ll => '20.2,-110.1'}))
  end

end
