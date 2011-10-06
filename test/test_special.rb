require File.expand_path('../helper', __FILE__)

class TestSpecial < Test::Unit::TestCase
  def setup
    @consumer = Foursquare::Merchant::Consumer.new('TOKEN')
    hash = {'id' => 'abcdefghjik'}
    @special = Foursquare::Merchant::Special.new(hash, @consumer)
  end

  def test_initialize
    assert_equal(Foursquare::Merchant::Special, @special.class)
    assert_kind_of(Foursquare::Merchant::Model, @special)
    assert_equal('abcdefghjik', @special.id)
  end

  def test_retire
    @special.stubs(:post).returns(true)
    assert @special.retire
  end

  def test_configuration
    response = {'special' => {'id' => 'config', 'count1' => 5}}
    @special.stubs(:get).returns(response)
    configuration = @special.configuration
    assert_equal(Foursquare::Merchant::Special, configuration.class)
    assert_equal(5, configuration.count1)
  end
end
