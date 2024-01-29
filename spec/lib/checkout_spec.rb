# frozen_string_literal: true

require_relative '../spec_helper'
RSpec.describe Checkout do
  describe '#initialize' do
    let(:products) { [] }
    let(:stock) { Stock.new(products:, pricing_rules:) }
    let(:pricing_rules) { [] }

    context 'when the stock is not provided' do
      it 'raises an error' do
        expect { Checkout.new }.to raise_error(ArgumentError)
      end
    end

    context 'when the stock is provided' do
      it 'initializes the checkout' do
        expect { Checkout.new(stock:) }.not_to raise_error
      end
    end
  end

  describe '#scan_item' do
    let(:products) { [Product.new(name: 'Green tea', price: 3.11, code: 'GR1')] }
    let(:stock) { Stock.new(products:, pricing_rules:) }
    let(:pricing_rules) { [] }

    let(:checkout) { Checkout.new(stock:) }

    context 'when the product code is not provided' do
      it 'raises an error' do
        expect { checkout.scan_item }.to raise_error(ArgumentError)
      end
    end

    context 'when the product code is provided' do
      it 'adds the product to the cart' do
        expect { checkout.scan_item('GR1') }.to change { checkout.cart.count }.by(1)
      end
    end
  end

  describe '#call' do
    let(:green_tea) { Product.new(name: 'Green tea', price: 3.11, code: 'GR1') }
    let(:strawberries) { Product.new(name: 'Strawberries', price: 5.00, code: 'SR1') }
    let(:coffee) { Product.new(name: 'Coffee', price: 11.23, code: 'CF1') }
    let(:products) { [green_tea, strawberries, coffee] }

    let(:stock) { Stock.new(products:, pricing_rules:) }
    let(:checkout) { Checkout.new(stock:) }

    context 'when no pricing rules are applied' do
      let(:pricing_rules) { [] }

      it 'calculates the total price and applies no discounts' do
        checkout.scan_item('GR1')
        checkout.scan_item('GR1')
        checkout.scan_item('SR1')
        checkout.scan_item('GR1')
        checkout.scan_item('CF1')
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

      it 'calculates the total price with discounts' do
        checkout.scan_item('GR1')
        checkout.scan_item('GR1')
        checkout.scan_item('SR1')
        checkout.scan_item('GR1')
        checkout.scan_item('CF1')
        checkout.call
        expect(checkout.total).to eq(25.56)
        expect(checkout.total_with_discount).to eq(22.45)
      end
    end
  end
end
