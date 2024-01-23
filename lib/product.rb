# frozen_string_literal: true

# Implements basic "model" for products
class Product
  def initialize(name:, price:, code:)
    @name = name
    @price = price
    @code = code
  end

  attr_reader :name, :price, :code
end
