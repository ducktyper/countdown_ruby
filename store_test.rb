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

  it "can register product again to update" do
    store = Store.new

    barcode = "001"
    name    = "apple"
    price   = 5

    store.register_product(barcode, name, price)
    store.register_product(barcode, "jass apple", 10)
    assert_equal(1, store.product_count())
    expected = "jass apple $10\ntotal $10"
    assert_equal expected, store.purchase(["001"])
  end

  it "can caculate total cost of given barcodes" do
    store = Store.new
    store.register_product("001", "apple", 10)
    store.register_product("002", "orange", 20)
    assert_equal(40, store.calculate_cost(["001", "001", "002"]))
  end

  it "can generate receipt from given barcodes" do
    store = Store.new
    store.register_product("001", "apple", 10)
    store.register_product("002", "orange", 20)
    expected = "apple $10\norange $20\ntotal $30"
    assert_equal(expected, store.receipt(["001", "002"]))
  end

  it "can purchase products with barcodes" do
    store = Store.new
    store.register_product("001", "apple", 10)
    store.register_product("002", "orange", 20)
    expected = "apple $10\norange $20\ntotal $30"
    assert_equal expected, store.purchase(["001", "002"])
  end

  it "shows purchase summary" do
    store = Store.new
    store.register_product("001", "apple", 10)
    store.register_product("002", "orange", 20)
    store.purchase(["001", "002"])
    time = Time.now.strftime("%d/%m/%Y")
    expect = [
      ["Number of Products", "Cost"],
      [2, 30]
    ]
    assert_equal expect, store.purchase_summary
  end

  it "can set discount to a product" do
    store = Store.new
    store.register_product("001", "apple", 10)
    store.set_discount_to_product("001", 1)
    assert_equal 9, store.calculate_cost(["001"])
  end

  it "shows discount to receipt" do
    store = Store.new
    store.register_product("001", "apple", 10)
    store.register_product("002", "orange", 20)
    store.set_discount_to_product("001", 1)
    expect = "apple $10\norange $20\napple -$1\ntotal $29"
    assert_equal expect, store.purchase(["001", "002"])
  end

  it "can set discount again to replace previous one" do
    store = Store.new
    store.register_product("001", "apple", 10)
    store.register_product("002", "orange", 20)
    store.set_discount_to_product("001", 1)
    store.set_discount_to_product("001", 2)
    expect = "apple $10\norange $20\napple -$2\ntotal $28"
    assert_equal expect, store.purchase(["001", "002"])
  end

end
