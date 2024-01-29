# frozen_string_literal: true

# Pricing rule that gives a free item for every X items bought
module PricingRules
  # Buy X get Y free
  class BuyGetFree < Base
    option :buy
    option :free

    attr_accessor :buy, :free

    def calculate_discount(product, quantity)
      return 0 if quantity < buy + free

      discounted_quantity = quantity / (buy + free)
      discounted_quantity * product.price
    end
  end
end
