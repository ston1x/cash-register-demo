# frozen_string_literal: true

module PricingRules
  # Buy X or more items and get a discount for each item
  class PriceDiscount < PricingRule
    def calculate_discount(_product, quantity)
      return 0 if quantity < options[:min_quantity]

      quantity * options[:new_price]
    end
  end
end
