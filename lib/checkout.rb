# frozen_string_literal: true

require 'bigdecimal/util'
require_relative 'stock'
require_relative 'product'
require_relative 'pricing_rule'
require_relative 'pricing_rules/buy_get_free'
require_relative 'pricing_rules/price_discount'
require_relative 'pricing_rules/fraction_discount'
require_relative 'receipt'

# Represents a process of checking out a customer's cart: scanning items, calculating
# total price, calculating discounts, and printing the receipt.
class Checkout
  LineItem = Struct.new(:product, :quantity, :total_price, :price_with_discount)

  def initialize(stock:)
    @stock = stock
    @cart = []
    @total = 0
  end

  attr_reader :stock, :cart, :line_items, :total, :total_with_discount

  # First you need to scan items one by one
  def scan_item(product_code)
    cart << product_code
    product = stock.find_product(code: product_code)
    @total += product.price
  end

  def call
    @line_items = scan_cart
    @total_with_discount = calculate_total_with_discount(@line_items)
    # accept_payment(@total_with_discount) (placeholder - out of scope)
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

  def calculate_total_with_discount(line_items)
    line_items.sum(&:price_with_discount).round(2)
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
