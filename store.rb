class Store
  def initialize
    @product_array = []
    @purchase_array = []
    @discount_array = []
  end

  def register_product(barcode, name, price)
    existing_product = @product_array.find {|product| product[0] == barcode}
    if existing_product
      @product_array.delete(existing_product)
    end

    new_product = [barcode, name, price]
    @product_array << new_product
  end

  def product_count
    @product_array.size
  end

  def calculate_cost(barcode_array)
    cost = 0
    barcode_array.each do |barcode|
      product = @product_array.find {|product| product[0] == barcode}
      cost = cost + product[2]
      discount = @discount_array.find {|discount| discount[0] == barcode}
      if discount
        cost = cost - discount[1]
      end
    end
    cost
  end

  def receipt(barcode_array)
    result = ""
    barcode_array.each do |barcode|
      product = @product_array.find {|product| product[0] == barcode}
      name = product[1]
      cost = product[2]
      result = result + "#{name} $#{cost}\n"
    end
    barcode_array.each do |barcode|
      product = @product_array.find {|product| product[0] == barcode}
      discount = @discount_array.find {|discount| discount[0] == barcode}
      if discount
        name = product[1]
        amount = discount[1]
        result = result + "#{name} -$#{amount}\n"
      end
    end
    result = result + "total $#{calculate_cost(barcode_array)}"
    result
  end

  def purchase(barcodes_array)
    @purchase_array << barcodes_array
    receipt(barcodes_array)
  end

  def purchase_summary
    result_array = []
    result_array << ["Number of Products", "Cost"]
    @purchase_array.each do |barcodes_array|
      n_products = barcodes_array.size
      cost       = calculate_cost(barcodes_array)
      result_array << [n_products, cost]
    end
    result_array
  end

  def set_discount_to_product(barcode, amount)
    discount = @discount_array.find {|discount| discount[0] == barcode}
    if discount
      @discount_array.delete(discount)
    end
    if amount == 0
      return
    end
    @discount_array << [barcode, amount]
  end

end
