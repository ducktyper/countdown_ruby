require 'minitest/autorun'
require './store'

describe "store" do

  it "starts with 0 item" do
    store = Store.new
    assert_equal(0, store.item_count())
  end

  it "can register item" do
    store = Store.new

    barcode = "001"
    name    = "apple"
    price   = 5

    store.register_item(barcode, name, price)
    assert_equal(1, store.item_count())
  end

end
