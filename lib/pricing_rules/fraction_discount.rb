# frozen_string_literal: true

module PricingRules
  # Buy X or more items and get a fraction discount for each item
  class FractionDiscount < Base
    option :min_quantity
    option :discount

    attr_accessor :min_quantity, :discount

    def calculate_discount(product, quantity)
      return 0 if quantity < min_quantity

      total_product_price = quantity * product.price
      product_price_with_discount = (quantity * product.price * discount)
      total_product_price - product_price_with_discount
    end
  end
end
