# frozen_string_literal: true

require 'bigdecimal/util'
require_relative 'stock'
require_relative 'product'
require_relative 'pricing_rule'
require_relative 'pricing_rules/buy_get_free'
require_relative 'pricing_rules/price_discount'
require_relative 'pricing_rules/fraction_discount'
require_relative 'receipt'

# This class is instantiated with a Stock (see stock.rb), and a cart. It represents a process of checking
# out a customer's cart: calculating the total price, calculating discounts, and printing the receipt.
class Checkout
  LineItem = Struct.new(:product, :quantity, :total_price, :price_with_discount)

  def initialize(stock:, cart:)
    @stock = stock
    @cart = cart
  end

  attr_reader :stock, :cart, :line_items, :total, :total_with_discount

  # TODO: IDEA: apparently instead of this I should implement a "#scan" method to consecutively scan every item
  # and then call the checkout method. This would allow scanning items one by one more realistically.
  def call
    @line_items = scan_cart
    @total = line_items.sum(&:total_price)
    @total_with_discount = line_items.sum(&:price_with_discount)
    # accept_payment(total_with_discount) (placeholder - out of scope)
    print_receipt(@line_items, @total, @total_with_discount)

    @total_with_discount
  end

  private

  def scan_cart
    cart.tally.map do |product_code, quantity|
      product = stock.find_product(code: product_code)
      total_price = calculate_total(product, quantity)
      price_with_discount = total_price - calculate_discount(product, quantity)

      LineItem.new(product:, quantity:, total_price:, price_with_discount:)
    end
  end

  def print_receipt(line_items, total, total_with_discount)
    Receipt.new(line_items:, total:, total_with_discount:).print
  end

  def calculate_total(product, quantity)
    quantity * product.price
  end

  def calculate_discount(product, quantity)
    pricing_rule = stock.pricing_rules.find { |rule| rule.applies_for?(product.code) }
    return 0 unless pricing_rule

    pricing_rule.call(product:, quantity:)
  end
end
