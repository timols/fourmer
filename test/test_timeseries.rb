require File.expand_path('../helper', __FILE__)

class TestTimeSeries < Test::Unit::TestCase
  def test_initialize_with_venue_id
    timeseries = Foursquare::Merchant::TimeSeries.new({:venueId => 'abc'})
    assert_kind_of(Hashie::Trash, timeseries)
    assert_equal('abc', timeseries.venue_id)
  end

  def test_initialize_no_venue_id
    assert_raise(ArgumentError) { timeseries = Foursquare::Merchant::TimeSeries.new({}) }
  end
end
