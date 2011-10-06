require File.expand_path('../helper', __FILE__)

class TestSpecials < Test::Unit::TestCase
  def setup
    @consumer = Foursquare::Merchant::Consumer.new('TOKEN')
  end

  def test_initialize
    specials_proxy = Foursquare::Merchant::Specials.new(@consumer)
    assert_instance_of(Foursquare::Merchant::Specials, specials_proxy)
  end

  def test_find
    response = stub(:parsed_response => {
      'meta' => {'code' => 200},
      'response' => {'special' => {'id' => 'abcdef'}}
      }
    )
    Foursquare::Merchant::Specials.stubs(:get).returns(response)
    assert_equal('abcdef', @consumer.specials.find('abcdef').id)
  end

  def test_add
    response = stub(:parsed_response => {
      'meta' => {'code' => 200},
      'response' => {'special' => {'id' => 'abcdef'}}
      }
    )
    Foursquare::Merchant::Specials.stubs(:post).returns(response)
    assert_equal('abcdef', @consumer.specials.add('abcdef').id)
  end

  def test_list
    items = [{'id' => 'abcdef'}, {'id' => 'fedcba'}]
    response = stub(:parsed_response => {
      'meta' => {'code' => 200},
      'response' => {'specials' => {'count' => 2, 'items' => items}}
      }
    )
    Foursquare::Merchant::Specials.stubs(:get).returns(response)
    specials = [Foursquare::Merchant::Special.new(items[0], @consumer),
                Foursquare::Merchant::Special.new(items[1], @consumer)]

    assert_equal(specials, @consumer.specials.list)
  end

  def test_search_no_lat_lng
    items = [{'id' => 'abcdef'}, {'id' => 'fedcba'}]
    response = stub(:parsed_response => {
      'meta' => {'code' => 200},
      'response' => {'specials' => {'count' => 2, 'items' => items}}
      }
    )
    Foursquare::Merchant::Specials.stubs(:get).returns(response)
    assert_raise(RuntimeError) { @consumer.specials.search({}) }
  end

  def test_search_with_lat_lng
    items = [{'id' => 'abcdef'}, {'id' => 'fedcba'}]
    response = stub(:parsed_response => {
      'meta' => {'code' => 200},
      'response' => {'specials' => {'count' => 2, 'items' => items}}
      }
    )
    Foursquare::Merchant::Specials.stubs(:get).returns(response)
    specials = [Foursquare::Merchant::Special.new(items[0], @consumer),
                Foursquare::Merchant::Special.new(items[1], @consumer)]

    assert_equal(specials, @consumer.specials.search({:ll => '20.2,-110.1'}))
  end
end