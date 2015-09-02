class Product < ActiveRecord::Base
end

class Store
  def initialize
    @purchase_array = []
    @discount_hash = {}
  end

  def register_product(barcode, name, price)
    product = Product.find_by("barcode" => barcode)
    if product == nil
      Product.create("barcode" => barcode, "name" => name, "price" => price)
    else
      product.update("barcode" => barcode, "name" => name, "price" => price)
    end
  end

  def product_count
    Product.count
  end

  def calculate_cost(barcode_array)
    cost = 0
    barcode_array.each do |barcode|
      product = Product.find_by("barcode" => barcode)
      cost = cost + product.price
      discount = @discount_hash[barcode]
      if discount
        cost = cost - discount["amount"]
      end
    end
    cost
  end

  def receipt(barcode_array)
    result = ""
    barcode_array.each do |barcode|
      product = Product.find_by("barcode" => barcode)
      name = product.name
      cost = product.price
      result = result + "#{name} #{format_money cost}\n"
    end
    barcode_array.each do |barcode|
      product = Product.find_by("barcode" => barcode)
      discount = @discount_hash[barcode]
      if discount
        name = product.name
        amount = discount["amount"]
        result = result + "#{name} -#{format_money amount}\n"
      end
    end
    result = result + "total #{format_money calculate_cost(barcode_array)}"
    result
  end

  def purchase(barcode_array)
    time_string = Time.now.strftime("%d/%m/%Y")
    @purchase_array << {"purchase_time" => time_string, "barcode_array" => barcode_array}
    receipt(barcode_array)
  end

  def purchase_summary
    result_array = []
    result_array << ["Time", "Number of Products", "Cost"]
    @purchase_array.each do |purchase|
      n_products = purchase["barcode_array"].size
      time       = purchase["purchase_time"]
      cost       = calculate_cost(purchase["barcode_array"])
      result_array << [time, n_products, cost]
    end
    result_array
  end

  def set_discount_to_product(barcode, amount)
    if amount == 0
      @discount_hash.delete(barcode)
      return
    end
    @discount_hash[barcode] = {"barcode" => barcode, "amount" => amount}
  end

  def format_money(amount)
    "$%.2f" % amount
  end

end
