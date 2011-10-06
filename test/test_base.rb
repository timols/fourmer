require File.expand_path('../helper', __FILE__)

module Foursquare
  module Merchant
    module Errors
      class TestError < APIError; end
    end
  end
end

class TestBase < Test::Unit::TestCase
  def setup
    @consumer = Foursquare::Merchant::Consumer.new('ACCESS_TOKEN')
    @base = Foursquare::Merchant::Base.new(@consumer)
  end

  def test_api_path
    assert_equal('https://api.foursquare.com/v2', Foursquare::Merchant::Base::API)
  end

  def test_initialize_with_consumer
    Foursquare::Merchant::Base.expects(:new).with(@consumer).returns(Foursquare::Merchant::Base)
    Foursquare::Merchant::Base.new(@consumer)
  end

  def test_get_success
    response = {'meta' => {'code' => 200}, 'response' => true}
    Foursquare::Merchant::Base.stubs(:get).returns(stub(:parsed_response => response))
    assert @base.get('/', {})
  end

  def test_post_success
    response = {'meta' => {'code' => 200}, 'response' => true}
    Foursquare::Merchant::Base.stubs(:post).returns(stub(:parsed_response => response))
    assert @base.post('/', {})
  end

  def test_get_failure
    response = {
      'meta' => {
        'code' => 400,
        'errorType' => 'test_error',
        'errorDetail' => 'This is a test error'
      }
    }
    Foursquare::Merchant::Base.stubs(:get).returns(stub(:parsed_response => response))
    assert_raise(Foursquare::Merchant::Errors::TestError) { @base.get('/', {}) }
  end

  def test_post_failure
    response = {
      'meta' => {
        'code' => 400,
        'errorType' => 'test_error',
        'errorDetail' => 'This is a test error'
      }
    }
    Foursquare::Merchant::Base.stubs(:post).returns(stub(:parsed_response => response))
    assert_raise(Foursquare::Merchant::Errors::TestError) { @base.post('/', {}) }
  end

end
