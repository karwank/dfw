class ProductsList < OpenStruct

  attr_reader :products

  def initialize
    @products = []
  end

  def get_products_sorted_by_price
    @products.sort_by(&:price_value)
  end

end