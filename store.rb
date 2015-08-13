class Store
  def initialize
    @product_hash = {}
    @purchase_array = []
    @discount_hash = {}
  end

  def register_product(barcode, name, price)
    new_product = {"barcode" => barcode, "name" => name, "price" => price}
    @product_hash[barcode] = new_product
  end

  def product_count
    @product_hash.size
  end

  def calculate_cost(barcode_array)
    cost = 0
    barcode_array.each do |barcode|
      product = @product_hash[barcode]
      cost = cost + product["price"]
      discount = @discount_array.find {|discount| discount["barcode"] == barcode}
      if discount
        cost = cost - discount["amount"]
      end
    end
    cost
  end

  def receipt(barcode_array)
    result = ""
    barcode_array.each do |barcode|
      product = @product_hash[barcode]
      name = product["name"]
      cost = product["price"]
      result = result + "#{name} $#{cost}\n"
    end
    barcode_array.each do |barcode|
      product = @product_hash[barcode]
      discount = @discount_array.find {|discount| discount["barcode"] == barcode}
      if discount
        name = product["name"]
        amount = discount["amount"]
        result = result + "#{name} -$#{amount}\n"
      end
    end
    result = result + "total $#{calculate_cost(barcode_array)}"
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
    discount = @discount_array.find {|discount| discount["barcode"] == barcode}
    if discount
      @discount_array.delete(discount)
    end
    if amount == 0
      return
    end
    @discount_hash[barcode] = {"barcode" => barcode, "amount" => amount}
  end

end
