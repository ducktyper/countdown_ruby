class Store
  def initialize
    @products = []
  end

  def register_product(barcode, name, price)
    new_product = [barcode, name, price]
    @products << new_product
  end

  def product_count
    @products.size
  end

  def calculate_cost(barcodes)
    cost = 0
    barcodes.each do |barcode|
      product = @products.find {|product| product[0] == barcode}
      cost = cost + product[2]
    end
    cost
  end

  def receipt(barcodes)
    result = ""
    barcodes.each do |barcode|
      product = @products.find {|product| product[0] == barcode}
      name = product[1]
      cost = product[2]
      result = result + "#{name} $#{cost}\n"
    end
    result = result + "total $#{calculate_cost(barcodes)}"
    result
  end

end
