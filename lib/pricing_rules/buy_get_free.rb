# frozen_string_literal: true

# Pricing rule that gives a free item for every X items bought
module PricingRules
  # Buy X get Y free
  class BuyGetFree < PricingRule
    def calculate_discount(product, quantity)
      return 0 if quantity < options[:buy] + options[:free]

      discounted_quantity = quantity / (options[:buy] + options[:free])
      discounted_quantity * product.price
    end
  end
end
