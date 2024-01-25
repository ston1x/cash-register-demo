# frozen_string_literal: true

# This class implements the Stock of the store.
# It represents available products and can search through them.
class Stock
  class ProductNotRegisteredError < StandardError; end
  # NOTE: Optionally, we could use dry-initializer here in order
  # to guarantee that the array of Product instances is passed.
  # NOTE: We initialize pricing rules **here** because cashiers should have
  # limited access and should not control pricing rules.
  # Setting pricing rules is more of a managements' responsibility.

  def initialize(products:, pricing_rules:)
    @products = products
    @pricing_rules = pricing_rules
  end

  attr_reader :products, :pricing_rules

  def find_product(code:)
    result = products.find { |product| product.code == code }
    # NOTE: Optionally we can return nil instead, just like in a store where
    # if the scanner does not identify the product, you just skip it.
    # Or accept a MODE or STRICT parameter/env variable that would control this behavior.
    raise ProductNotRegisteredError, "Product with code #{code} is not registered" unless result

    result
  end

  def add_product(product)
    products << product
    raise "Product with code #{product.code} is already registered" unless find_product(code: product.code)
  end

  def remove_product(code:)
    products.delete(find_product(code:))
  end
end
