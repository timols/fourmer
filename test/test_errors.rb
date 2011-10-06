require File.expand_path('../helper', __FILE__)

class TestErrors < Test::Unit::TestCase
  def test_api_error
    assert_kind_of(StandardError, Foursquare::Merchant::Errors::APIError.new)
  end

  def test_oauth_error
    assert_kind_of(Foursquare::Merchant::Errors::APIError, Foursquare::Merchant::Errors::OAuthError.new)
  end

  def test_new_error
    error = Foursquare::Merchant::Errors.new('TestError', 'This is a test error')
    assert_equal('Foursquare::Merchant::Errors::TestError', error.class.name)
    assert_equal('This is a test error', error.message)
  end
end