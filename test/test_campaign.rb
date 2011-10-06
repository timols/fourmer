require File.expand_path('../helper', __FILE__)

class TestCampaign < Test::Unit::TestCase
  def setup
    @consumer = Foursquare::Merchant::Consumer.new('TOKEN')
    hash = {'venues' => {'count' => 1, 'items' => [{'id' => 'abcdefghjik'}]}}
    @campaign = Foursquare::Merchant::Campaign.new(hash, @consumer)
  end

  def test_initialize
    assert_equal(Foursquare::Merchant::Campaign, @campaign.class)
    assert_kind_of(Foursquare::Merchant::Model, @campaign)
    assert_equal(['abcdefghjik'], @campaign.venue_ids)
  end

  def test_timeseries
    Foursquare::Merchant::TimeSeries.stubs(:new).returns([])
    @campaign.stubs(:get).returns({'timeseries' => []})
    assert_equal([], @campaign.timeseries)
  end

  def test_start
    @campaign.stubs(:post).returns(true)
    assert @campaign.start
  end

  def test_end
    @campaign.stubs(:post).returns(true)
    assert @campaign.end
  end

  def test_delete
    @campaign.stubs(:post).returns(true)
    assert @campaign.delete
  end
end
