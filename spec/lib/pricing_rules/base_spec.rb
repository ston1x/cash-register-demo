# frozen_string_literal: true

require_relative '../../spec_helper'
RSpec.describe PricingRules::Base do
  subject(:pricing_rule) do
    described_class.new(
      code: 'some_rule',
      product_codes: [product.code]
    )
  end
  let(:product) { Product.new(name: 'Green tea', price: 3.11, code: 'GR1') }

  describe '#initialize' do
    it 'initializes a new pricing rule with the provided attributes' do
      expect(pricing_rule.product_codes).to eq(['GR1'])
    end
  end

  describe '#applies_for?' do
    context 'when the product code is included in the pricing rule' do
      it 'returns true' do
        expect(pricing_rule.applies_for?('GR1')).to eq(true)
      end
    end

    context 'when the product code is not included in the pricing rule' do
      it 'returns false' do
        expect(pricing_rule.applies_for?('SR1')).to eq(false)
      end
    end
  end

  describe '#call' do
    it 'raises NotImplementedError' do
      expect { pricing_rule.call(product:, quantity: 2) }.to raise_error(NotImplementedError)
    end

    context 'when the product code is not included in the pricing rule' do
      let(:product2) { Product.new(name: 'Strawberries', price: 5.00, code: 'SR1') }

      it 'raises UnsupportedProductError' do
        expect { pricing_rule.call(product: product2, quantity: 2) }
          .to raise_error(described_class::UnsupportedProductError)
      end
    end
  end
end
