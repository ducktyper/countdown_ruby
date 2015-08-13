require 'minitest/autorun'
require './store'

describe "store" do

  it "starts with 0 product" do
    store = Store.new
    assert_equal(0, store.product_count())
  end

  it "can register product" do
    store = Store.new

    barcode = "001"
    name    = "apple"
    price   = 5

    store.register_product(barcode, name, price)
    assert_equal(1, store.product_count())
  end

  it "can caculate total cost of given barcodes" do
    store = Store.new
    store.register_product("001", "apple", 10)
    store.register_product("002", "orange", 20)
    assert_equal(40, store.calculate_cost(["001", "001", "002"]))
  end

end
