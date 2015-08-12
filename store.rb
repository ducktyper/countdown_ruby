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

end
