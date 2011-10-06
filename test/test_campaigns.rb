require File.expand_path('../helper', __FILE__)

class TestCampaign < Test::Unit::TestCase
  def setup
    @consumer = Foursquare::Merchant::Consumer.new('TOKEN')
  end

  def test_initialize
    campaigns_proxy = Foursquare::Merchant::Campaigns.new(@consumer)
    assert_instance_of(Foursquare::Merchant::Campaigns, campaigns_proxy)
  end

  def test_find
    response = stub(:parsed_response => {
      'meta' => {'code' => 200},
      'response' => {'campaign' => {'id' => 'abcdef'}}
      }
    )
    Foursquare::Merchant::Campaigns.stubs(:get).returns(response)
    assert_equal('abcdef', @consumer.campaigns.find('abcdef').id)
  end

  def test_add
    response = stub(:parsed_response => {
      'meta' => {'code' => 200},
      'response' => {'campaign' => {'id' => 'abcdef'}}
      }
    )
    Foursquare::Merchant::Campaigns.stubs(:post).returns(response)
    assert_equal('abcdef', @consumer.campaigns.add('abcdef').id)
  end

  def test_list
    items = [{'id' => 'abcdef'}, {'id' => 'abcdef'}]
    response = stub(:parsed_response => {
      'meta' => {'code' => 200},
      'response' => {'campaigns' => {'count' => 2, 'items' => items}}
      }
    )
    Foursquare::Merchant::Campaigns.stubs(:get).returns(response)
    campaigns = [Foursquare::Merchant::Campaign.new(items[0], @consumer),
                 Foursquare::Merchant::Campaign.new(items[0], @consumer)]

    assert_equal(campaigns, @consumer.campaigns.list)
  end
end