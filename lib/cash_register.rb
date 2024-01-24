# frozen_string_literal: true

require 'bigdecimal/util'
require_relative 'stock'
require_relative 'product'
require_relative 'pricing_rule'
require_relative 'pricing_rules/buy_get_free'
require_relative 'pricing_rules/price_discount'
require_relative 'pricing_rules/fraction_discount'

# This class is instantiated with a Stock (see stock.rb).
# The CashRegister is being called (#calculate_total) when a customer comes with a cart to the
# cash register. Customer provides their cart and the cash register calculates the total price,
# taking into account the pricing rules of each item.
class CashRegister
  def initialize(stock:)
    @stock = stock
  end

  attr_reader :stock

  def calculate_total(cart)
    cart.sum do |product_code, quantity|
      product = @stock.find_product(code: product_code)
      calculate_price(product, quantity)
    end
  end

  private

  def calculate_price(product, quantity)
    total_price = quantity * product.price
    discounted_price = total_price - calculate_discount(product, quantity)
    print_receipt(product, quantity, total_price, discounted_price)
    discounted_price
  end

  # Idea: Receipt can be a class which has total_price, list of items, printable format etc.
  def print_receipt(product, quantity, total_price, discounted_price)
    product_line = "[#{product.code}] #{product.name.ljust(15)} x#{quantity} "\
    "- #{total_price.to_f.to_s.ljust(5)} (#{discounted_price.to_f})"
    puts product_line
  end

  def calculate_discount(product, quantity)
    pricing_rule = stock.pricing_rules.find { |rule| rule.applies_for?(product.code) }
    return 0 unless pricing_rule

    pricing_rule.call(product:, quantity:)
  end
end
