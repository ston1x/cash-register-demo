# frozen_string_literal: true

require_relative '../../spec_helper'
RSpec.describe 'PricingRules::FractionDiscount' do
  describe '#calculate_discount' do
    let(:pricing_rule) { PricingRules::FractionDiscount.new(product_codes: [product.code], options:) }
    let(:product) { Product.new(name: 'Green tea', price: 5, code: 'GR1') }
    let(:options) { { min_quantity: 2, discount: 1.0 / 2.0 } }

    context 'when the quantity is less than the minimum required' do
      it 'returns 0' do
        expect(pricing_rule.calculate_discount(product, 1)).to eq(0)
      end
    end

    context 'when the quantity is greater than the minimum required' do
      it { expect(pricing_rule.calculate_discount(product, 2)).to eq(5.0) }
      it { expect(pricing_rule.calculate_discount(product, 3)).to eq(7.5) }
      it { expect(pricing_rule.calculate_discount(product, 4)).to eq(10.0) }
      it { expect(pricing_rule.calculate_discount(product, 5)).to eq(12.5) }
    end
  end
end
