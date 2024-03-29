# frozen_string_literal: true

require_relative 'lib/checkout'

products = [
  Product.new(name: 'Green tea', price: 3.11, code: 'GR1'),
  Product.new(name: 'Strawberries', price: 5.00, code: 'SR1'),
  Product.new(name: 'Coffee', price: 11.23, code: 'CF1')
]

pricing_rules = [
  PricingRules::BuyGetFree.new(code: 'buy_one_get_one_free', product_codes: ['GR1'], buy: 1, free: 1),
  PricingRules::PriceDiscount.new(code: 'stay_fresh', product_codes: ['SR1'], min_quantity: 3, new_price: 4.50),
  PricingRules::FractionDiscount.new(code: 'coffee_time', product_codes: ['CF1'], min_quantity: 3, discount: 2.0 / 3.0)
]

stock = Stock.new(products:, pricing_rules:)

# Updating an existing pricing rule on the go
stock.find_pricing_rule(code: 'stay_fresh').new_price = 4.25

checkout = Checkout.new(stock:)
checkout.scan_item('GR1')
checkout.scan_item('SR1')
checkout.scan_item('GR1')
checkout.scan_item('CF1')

checkout.call

# Finishing the 'Buy One Get One Free' campaign
stock.remove_pricing_rule(code: 'buy_one_get_one_free')
