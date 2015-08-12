require 'minitest/autorun'
require './store'

describe "store" do

  it "store starts with 0 item" do
    store = Store.new
    assert_equal(0, store.item_count())
  end

end
