# frozen_string_literal: true

module PricingRules
  # Parent class for pricing rules. It specifies how they are instantiated and
  # provides a way to figure out if a pricing rule applies for a given product.
  class Base
    extend Dry::Initializer

    class UnsupportedProductError < StandardError; end

    option :code, proc(&:to_s)
    option :product_codes, default: proc { [] }

    def call(product:, quantity:)
      validate_product_code!(product.code)
      calculate_discount(product, quantity)
    end

    def calculate_discount(product, quantity)
      raise NotImplementedError
    end

    def applies_for?(product_code)
      product_codes.include?(product_code)
    end

    def validate_product_code!(product_code)
      return if applies_for?(product_code)

      raise UnsupportedProductError, "Pricing rule #{code} does not apply for product #{product_code}"
    end
  end
end
