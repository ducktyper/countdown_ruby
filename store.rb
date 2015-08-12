class Store
  def initialize
    @items = []
  end

  def register_item(barcode, name, price)
    new_item = [barcode, name, price]
    @items << new_item
  end

  def item_count
    @items.size
  end

end
