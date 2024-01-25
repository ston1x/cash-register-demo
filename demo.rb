# frozen_string_literal: true

require_relative 'lib/checkout'

products = [
  Product.new(name: 'Green tea', price: 3.11, code: 'GR1'),
  Product.new(name: 'Strawberries', price: 5.00, code: 'SR1'),
  Product.new(name: 'Coffee', price: 11.23, code: 'CF1')
]

pricing_rules = [
  PricingRules::BuyGetFree.new(product_codes: ['GR1'], options: { buy: 1, free: 1 }),
  PricingRules::PriceDiscount.new(product_codes: ['SR1'], options: { min_quantity: 3, new_price: 4.50 }),
  PricingRules::FractionDiscount.new(product_codes: ['CF1'], options: { min_quantity: 3, discount: 2.0 / 3.0 })
]

stock = Stock.new(products:, pricing_rules:)
cart = %w[GR1 GR1 SR1 CF1]
checkout = Checkout.new(stock:, cart:)
checkout.call
