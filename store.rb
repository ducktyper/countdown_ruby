require 'json'

class Product < ActiveRecord::Base
end
class Discount < ActiveRecord::Base
  # TODO: set one to one relationship to product
end
class Purchase < ActiveRecord::Base
  has_and_belongs_to_many :products
  def barcode_array
    array = []
    products.each do |product|
      array << product.barcode
    end
    array
  end
end

class Store
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
      discount = Discount.find_by("barcode" => barcode)
      if discount
        cost = cost - discount.amount
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
      discount = Discount.find_by("barcode" => barcode)
      if discount
        name = product.name
        amount = discount.amount
        result = result + "#{name} -#{format_money amount}\n"
      end
    end
    result = result + "total #{format_money calculate_cost(barcode_array)}"
    result
  end

  def purchase(barcode_array)
    time_string = Time.now.strftime("%d/%m/%Y")

    products = []
    barcode_array.each do |barcode|
      product = Product.find_by("barcode" => barcode)
      products << product
    end

    Purchase.create(
      purchase_time: time_string,
      products:      products,
      total_cost:    calculate_cost(barcode_array)
    )
    receipt(barcode_array)
  end

  def purchase_summary
    result_array = []
    result_array << ["Time", "Number of Products", "Cost"]
    Purchase.all.each do |purchase|
      n_products = purchase.barcode_array.size
      time       = purchase.purchase_time
      cost       = purchase.total_cost
      result_array << [time, n_products, cost]
    end
    result_array
  end

  def set_discount_to_product(barcode, amount)
    discount = Discount.find_by("barcode" => barcode)
    if amount == 0
      if discount != nil
        discount.delete()
      end
      return
    end
    if discount == nil
      Discount.create("barcode" => barcode, "amount" => amount)
    else
      discount.update("barcode" => barcode, "amount" => amount)
    end
  end

  def format_money(amount)
    "$%.2f" % amount
  end

end
