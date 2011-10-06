require File.expand_path('../helper', __FILE__)

class TestVenueStats < Test::Unit::TestCase

  def test_initialize
    stats = Foursquare::Merchant::VenueStats.new({'sharing' => {"twitter"=>233, "facebook"=>203}})
    assert_kind_of(Hashie::Trash, stats)
    assert_equal({"twitter"=>233, "facebook"=>203}, stats.sharing)
  end

end
