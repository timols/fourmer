require File.expand_path('../helper', __FILE__)

class TestVenueGroup < Test::Unit::TestCase
  def setup
    @consumer = Foursquare::Merchant::Consumer.new('TOKEN')
    hash = {'id' => 'abcdefghjik'}
    @venue_group = Foursquare::Merchant::VenueGroup.new(hash, @consumer)
  end

  def test_initialize_no_venue_ids
    assert_equal(Foursquare::Merchant::VenueGroup, @venue_group.class)
    assert_kind_of(Foursquare::Merchant::Model, @venue_group)
    assert_equal('abcdefghjik', @venue_group.id)
  end

  def test_initialize_with_venue_ids
    hash = {'id' => 'abcdefghjik', 'venues' => {'items' => [{'id' => 'a'}]}}
    venue_group = Foursquare::Merchant::VenueGroup.new(hash, @consumer)
    venue = Foursquare::Merchant::Venue.new(hash['venues']['items'][0], @consumer)
    assert_equal([venue], venue_group.venues)
  end

  def test_delete
    @venue_group.stubs(:post).returns(true)
    assert @venue_group.delete
  end

  def test_add_venue
    @venue_group.stubs(:post).returns(true)
    assert @venue_group.add_venue(['abc', 'def'])
  end

  def test_remove_venue
    @venue_group.stubs(:post).returns(true)
    assert @venue_group.remove_venue(['abc', 'def'])
  end

end
