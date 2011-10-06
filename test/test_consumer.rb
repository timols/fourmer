require File.expand_path('../helper', __FILE__)

class TestConsumer < Test::Unit::TestCase
  def setup
    @consumer_token = Foursquare::Merchant::Consumer.new('ACCESS_TOKEN')
    @consumer_id = Foursquare::Merchant::Consumer.new('CLIENT_ID', 'CLIENT_SECRET')
  end

  def test_initialize_no_args
    assert_raise ArgumentError do
      Foursquare::Merchant::Consumer.new
    end
  end

  def test_initialize_one_arg
    assert_nothing_raised ArgumentError do
      Foursquare::Merchant::Consumer.new('ACCESS_TOKEN')
    end
    assert_equal('ACCESS_TOKEN', @consumer_token.oauth_token)
  end

  def test_initialize_two_args
    assert_nothing_raised ArgumentError do
      Foursquare::Merchant::Consumer.new('CLIENT_ID', 'CLIENT_SECRET')
    end
    assert_equal('CLIENT_ID', @consumer_id.client_id)
    assert_equal('CLIENT_SECRET', @consumer_id.client_secret)
  end

  def test_authorize_url_no_args
    assert_raise(ArgumentError) { @consumer_id.authorize_url }
  end
  
  def test_authorize_url_invalid_callback_url
    callback_url = "path/to/some/url"
    assert_raise(ArgumentError) { @consumer_id.authorize_url(callback_url) }
  end

  def test_authorize_url
    callback_url = "http://path/to/some/url"
    assert_nothing_raised(RuntimeError) { @consumer_id.authorize_url(callback_url) }
    query = {
      :client_id => 'CLIENT_ID',
      :response_type => 'code',
      :redirect_uri => callback_url
    }.map { |k,v| "#{k}=#{v}"}.join('&')
    response = "https://foursquare.com/oauth2/authenticate?#{query}"
    assert_equal(response, @consumer_id.authorize_url(callback_url))
  end

  def test_access_token
    response = stub(:code => 200, :parsed_response => {'access_token' => 'ABCDEF'})
    Foursquare::Merchant::Consumer.stubs(:get).returns(response)
    assert_equal('ABCDEF', @consumer_id.access_token('SOME CODE', 'http://some.url.com'))
  end

  def test_access_token_fail
    response = stub(:code => 400, :parsed_response => {'error' => 'Some error'})
    Foursquare::Merchant::Consumer.stubs(:get).returns(response)
    assert_raise(Foursquare::Merchant::Errors::OAuthError) do
      @consumer_id.access_token('SOME CODE', 'http://some.url.com')
    end
  end

  def test_access_token_with_consumer_only_initialized_with_oauth_token
    assert_raise(RuntimeError) { @consumer_token.access_token('code', 'http://call.com') }
  end

  def test_access_token_with_consumer_initialized_with_invalid_params
    consumer = Foursquare::Merchant::Consumer.new('ID', nil)
    assert_raise(RuntimeError) { consumer.access_token('code', 'http://call.com') }

    consumer = Foursquare::Merchant::Consumer.new(nil, 'SECRET')
    assert_raise(RuntimeError) { consumer.access_token('code', 'http://call.com') }
  end

  def test_access_token_with_invalid_arguments
    assert_raise(RuntimeError) { @consumer_id.access_token(nil, 'http://call.com') }
    assert_raise(RuntimeError) { @consumer_id.access_token('code', 'call.com') }
    assert_raise(RuntimeError) { @consumer_id.access_token('code', nil) }
  end

  def test_valid_oauth_url
    assert_equal('https://foursquare.com/oauth2', Foursquare::Merchant::Consumer::OAUTH)
  end

  def test_campaigns
    @consumer_token.expects(:campaigns).returns(Foursquare::Merchant::Campaigns.new(@consumer_token))
    @consumer_token.campaigns
  end

  def test_venues
    @consumer_token.expects(:venues).returns(Foursquare::Merchant::Venues.new(@consumer_token))
    @consumer_token.venues
  end

  def test_venue_groups
    @consumer_token.expects(:venue_groups).returns(Foursquare::Merchant::VenueGroups.new(@consumer_token))
    @consumer_token.venue_groups
  end

  def test_specials
    @consumer_token.expects(:specials).returns(Foursquare::Merchant::Specials.new(@consumer_token))
    @consumer_token.specials
  end

end
