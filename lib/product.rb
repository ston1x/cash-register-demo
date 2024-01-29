# frozen_string_literal: true

# Implements basic "model" for products
class Product
  extend Dry::Initializer
  option :name
  option :price
  option :code

  attr_accessor :name, :price, :code
end
