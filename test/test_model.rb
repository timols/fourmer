require File.expand_path('../helper', __FILE__)

class TestModel < Test::Unit::TestCase
  def setup
    @model = Foursquare::Merchant::Model.new({}, [])
  end

  def test_inheritance
    assert_kind_of(Hashie::Trash, @model)
  end

  def test_get
    assert_respond_to(@model, :get)
  end

  def test_post
    assert_respond_to(@model, :post)
  end

  def test_listify_array
    assert_equal('abc,def', @model.send(:listify, ['abc', 'def']))
  end

  def test_listify_string
    assert_equal('abc,def', @model.send(:listify, 'abc,def'))
  end

  def test_listify_other
    assert_raise(ArgumentError) { @model.send(:listify, nil) }
  end
end
