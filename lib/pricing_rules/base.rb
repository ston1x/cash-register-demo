# frozen_string_literal: true

module PricingRules
  # Parent class for pricing rules. It specifies how they are instantiated and
  # provides a way to figure out if a pricing rule applies for a given product.
  class Base
    class UnsupportedProductError < StandardError; end

    def initialize(code:, product_codes:, options:)
      @code = code
      @product_codes = product_codes
      @options = options
    end

    attr_accessor :code, :product_codes, :options

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
