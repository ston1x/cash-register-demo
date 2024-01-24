# frozen_string_literal: true

module PricingRules
  # Buy X or more items and get a fraction discount for each item
  class FractionDiscount < PricingRule
    def calculate_discount(product, quantity)
      return 0 if quantity < options[:min_quantity]

      quantity * product.price * options[:discount]
    end
  end
end
