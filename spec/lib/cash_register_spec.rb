# frozen_string_literal: true

require_relative '../spec_helper'
RSpec.describe CashRegister do
  describe '#calculate_total' do
    let(:green_tea) { Product.new(name: 'Green tea', price: 3.11, code: 'GR1') }
    let(:strawberries) { Product.new(name: 'Strawberries', price: 5.00, code: 'SR1') }
    let(:coffee) { Product.new(name: 'Coffee', price: 11.23, code: 'CF1') }
    let(:products) { [green_tea, strawberries, coffee] }

    let(:stock) { Stock.new(products:, pricing_rules:) }
    let(:cash_register) { CashRegister.new(stock:) }

    context 'when no pricing rules are applied' do
      let(:pricing_rules) { [] }
      let(:cart) { { 'GR1' => 3, 'SR1' => 1, 'CF1' => 1 } }

      it 'calculates the total price' do
        expect(cash_register.calculate_total(cart)).to eq(25.56)
      end
    end

    context 'when pricing rules are applied' do
      let(:pricing_rules) do
        [
          PricingRules::BuyGetFree.new(
            product_codes: [green_tea.code],
            options: { buy: 1, free: 1 }
          ),
          PricingRules::PriceDiscount.new(
            product_codes: [strawberries.code],
            options: { min_quantity: 3, new_price: 4.50 }
          ),
          PricingRules::FractionDiscount.new(
            product_codes: [coffee.code],
            options: { min_quantity: 3, discount: 0.5 }
          )
        ]
      end
      let(:cart) { { 'GR1' => 3, 'SR1' => 1, 'CF1' => 1 } }

      it 'calculates the total price' do
        expect(cash_register.calculate_total(cart)).to eq(22.45)
      end
    end
  end
end
