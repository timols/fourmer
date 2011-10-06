require File.expand_path('../helper', __FILE__)

class TestVenue < Test::Unit::TestCase
  def setup
    @consumer = Foursquare::Merchant::Consumer.new('TOKEN')
    hash = {'id' => 'abcdefghjik'}
    @venue = Foursquare::Merchant::Venue.new(hash, @consumer)
  end

  def test_initialize
    assert_equal(Foursquare::Merchant::Venue, @venue.class)
    assert_kind_of(Foursquare::Merchant::Model, @venue)
    assert_equal('abcdefghjik', @venue.id)
  end

  def test_fetch
    response = {'venue' => {'id' => 'new_venue'}}
    @venue.stubs(:get).returns(response)
    assert_kind_of(Foursquare::Merchant::Venue, @venue.fetch)
    assert_equal('new_venue', @venue.fetch.id)
    assert_not_equal(@venue, @venue.fetch)
  end

  def test_stats
    @venue.stubs(:get).returns({'stats' => {'sharing' => {"twitter"=>233, "facebook"=>203}}})
    stats = Foursquare::Merchant::VenueStats.new({'sharing' => {"twitter"=>233, "facebook"=>203}})
    assert_equal(stats, @venue.stats)
  end

  def test_edit
    response = {'venue' => {'id' => 'new_id'}}
    @venue.stubs(:post).returns(response)
    @venue.stubs(:get).returns(response)

    assert_equal('abcdefghjik', @venue.id)
    @venue.edit({'id' => 'new_id'})
    assert_equal('new_id', @venue.id)
  end
end
