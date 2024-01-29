# frozen_string_literal: true

module PricingRules
  # Buy X or more items and get a discount for each item
  class PriceDiscount < Base
    def calculate_discount(product, quantity)
      return 0 if quantity < options[:min_quantity]

      (quantity * product.price) - (quantity * options[:new_price])
    end
  end
end
