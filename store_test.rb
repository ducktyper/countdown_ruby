require 'minitest/autorun'
require 'active_record'
require './store'

ActiveRecord::Base.establish_connection adapter: "sqlite3", database: ":memory:"
ActiveRecord::Schema.verbose = false
ActiveRecord::Base.time_zone_aware_attributes = true
ActiveRecord::Schema.define do
  create_table "products" do |t|
    t.string   "barcode",       limit: 255
    t.string   "name",          limit: 255
    t.decimal  "price",         precision: 8, scale: 2
  end
end

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
    expected = "jass apple $10.00\ntotal $10.00"
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
    expected = "apple $10.00\norange $20.00\ntotal $30.00"
    assert_equal(expected, store.receipt(["001", "002"]))
  end

  it "can purchase products with barcodes" do
    store = Store.new
    store.register_product("001", "apple", 10)
    store.register_product("002", "orange", 20)
    expected = "apple $10.00\norange $20.00\ntotal $30.00"
    assert_equal expected, store.purchase(["001", "002"])
  end

  it "shows purchase summary" do
    store = Store.new
    store.register_product("001", "apple", 10)
    store.register_product("002", "orange", 20)
    store.purchase(["001", "002"])
    time = Time.now.strftime("%d/%m/%Y")
    expect = [
      ["Time", "Number of Products", "Cost"],
      [time, 2, 30]
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
    expect = "apple $10.00\norange $20.00\napple -$1.00\ntotal $29.00"
    assert_equal expect, store.purchase(["001", "002"])
  end

  it "can set discount again to replace previous one" do
    store = Store.new
    store.register_product("001", "apple", 10)
    store.register_product("002", "orange", 20)
    store.set_discount_to_product("001", 1)
    store.set_discount_to_product("001", 2)
    expect = "apple $10.00\norange $20.00\napple -$2.00\ntotal $28.00"
    assert_equal expect, store.purchase(["001", "002"])
  end

  it "can set 0 discount to clear previous one" do
    store = Store.new
    store.register_product("001", "apple", 10)
    store.register_product("002", "orange", 20)
    store.set_discount_to_product("001", 1)
    store.set_discount_to_product("001", 0)
    expect = "apple $10.00\norange $20.00\ntotal $30.00"
    assert_equal expect, store.purchase(["001", "002"])
  end

end
