# frozen_string_literal: true

module PricingRules
  # Buy X or more items and get a discount for each item
  class PriceDiscount < Base
    option :min_quantity
    option :new_price

    attr_accessor :min_quantity, :new_price

    def calculate_discount(product, quantity)
      return 0 if quantity < min_quantity

      (quantity * product.price) - (quantity * new_price)
    end
  end
end
