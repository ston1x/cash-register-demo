# frozen_string_literal: true

# Parent class for pricing rules. It specifies how they are instantiated and
# provides a way to figure out if a pricing rule applies for a given product.
class PricingRule
  class UnsupportedProductError < StandardError; end

  def initialize(code:, product_codes:, options:)
    @code = code
    @product_codes = product_codes
    @options = options
  end

  attr_reader :code, :product_codes, :options

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

  private

  def validate_product_code!(product_code)
    return if product_codes.include?(product_code)

    raise UnsupportedProductError, "Product with code #{product_code} is not supported"
  end
end
