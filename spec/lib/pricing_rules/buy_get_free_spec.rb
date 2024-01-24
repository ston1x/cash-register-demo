# frozen_string_literal: true

require_relative '../../spec_helper'
RSpec.describe 'PricingRules::BuyGetFree' do
  describe '#calculate_discount' do
    let(:pricing_rule) { PricingRules::BuyGetFree.new(product_codes: ['GR1'], options:) }
    let(:product) { Product.new(name: 'Green tea', price: 5, code: 'GR1') }

    describe 'buy one get one free' do
      let(:options) { { buy: 1, free: 1 } }

      context 'when the quantity is less than the minimum required' do
        it 'returns 0' do
          expect(pricing_rule.calculate_discount(product, 1)).to eq(0)
        end
      end

      context 'when the quantity is greater than the minimum required' do
        it { expect(pricing_rule.calculate_discount(product, 2)).to eq(5) }
        it { expect(pricing_rule.calculate_discount(product, 3)).to eq(5) }
        it { expect(pricing_rule.calculate_discount(product, 4)).to eq(10) }
        it { expect(pricing_rule.calculate_discount(product, 5)).to eq(10) }
        it { expect(pricing_rule.calculate_discount(product, 6)).to eq(15) }
        it { expect(pricing_rule.calculate_discount(product, 7)).to eq(15) }
      end
    end

    describe 'buy two get one free' do
      let(:pricing_rule) { PricingRules::BuyGetFree.new(product_codes: ['GR1'], options: { buy: 2, free: 1 }) }

      context 'when the quantity is less than the minimum required' do
        it { expect(pricing_rule.calculate_discount(product, 1)).to eq(0) }
        it { expect(pricing_rule.calculate_discount(product, 2)).to eq(0) }
      end

      context 'when the quantity is greater than the minimum required' do
        it { expect(pricing_rule.calculate_discount(product, 3)).to eq(5) }
        it { expect(pricing_rule.calculate_discount(product, 4)).to eq(5) }
        it { expect(pricing_rule.calculate_discount(product, 5)).to eq(5) }
        it { expect(pricing_rule.calculate_discount(product, 6)).to eq(10) }
        it { expect(pricing_rule.calculate_discount(product, 7)).to eq(10) }
        it { expect(pricing_rule.calculate_discount(product, 8)).to eq(10) }
        it { expect(pricing_rule.calculate_discount(product, 9)).to eq(15) }
      end
    end
  end
end
