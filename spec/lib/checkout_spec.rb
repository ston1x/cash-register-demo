# frozen_string_literal: true

require_relative '../spec_helper'
RSpec.describe Checkout do
  describe '#call' do
    let(:green_tea) { Product.new(name: 'Green tea', price: 3.11, code: 'GR1') }
    let(:strawberries) { Product.new(name: 'Strawberries', price: 5.00, code: 'SR1') }
    let(:coffee) { Product.new(name: 'Coffee', price: 11.23, code: 'CF1') }
    let(:products) { [green_tea, strawberries, coffee] }

    let(:stock) { Stock.new(products:, pricing_rules:) }
    let(:checkout) { Checkout.new(stock:, cart:) }

    context 'when no pricing rules are applied' do
      let(:pricing_rules) { [] }
      let(:cart) { %w[GR1 GR1 GR1 SR1 CF1] }

      it 'calculates the total price and applies no discounts' do
        checkout.call
        expect(checkout.total).to eq(25.56)
        expect(checkout.total_with_discount).to eq(25.56)
      end
    end

    context 'when pricing rules are applied' do
      let(:pricing_rules) do
        [
          PricingRules::BuyGetFree.new(
            code: 'buy_one_get_one_free',
            product_codes: [green_tea.code],
            options: { buy: 1, free: 1 }
          ),
          PricingRules::PriceDiscount.new(
            code: 'veggie_day',
            product_codes: [strawberries.code],
            options: { min_quantity: 3, new_price: 4.50 }
          ),
          PricingRules::FractionDiscount.new(
            code: 'share_the_coffee',
            product_codes: [coffee.code],
            options: { min_quantity: 3, discount: 0.5 }
          )
        ]
      end
      let(:cart) { %w[GR1 GR1 GR1 SR1 CF1] }

      it 'calculates the total price with discounts' do
        checkout.call
        expect(checkout.total).to eq(25.56)
        expect(checkout.total_with_discount).to eq(22.45)
      end
    end
  end
end
