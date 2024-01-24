# frozen_string_literal: true

require_relative '../spec_helper'
RSpec.describe 'PricingRule' do
  describe '#initialize' do
    let(:pricing_rule) { PricingRule.new(product_codes: ['GR1'], options: { buy: 1, get: 1 }) }

    it 'initializes a new pricing rule with the provided attributes' do
      expect(pricing_rule.product_codes).to eq(['GR1'])
      expect(pricing_rule.options).to eq({ buy: 1, get: 1 })
    end
  end

  describe '#applies_for?' do
    let(:pricing_rule) { PricingRule.new(product_codes: ['GR1'], options: { buy: 1, get: 1 }) }

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
    let(:pricing_rule) { PricingRule.new(product_codes: [product.code], options: { buy: 1, get: 1 }) }
    let(:product) { Product.new(name: 'Green tea', price: 3.11, code: 'GR1') }

    it 'raises NotImplementedError' do
      expect { pricing_rule.call(product:, quantity: 2) }.to raise_error(NotImplementedError)
    end

    context 'when the product code is not included in the pricing rule' do
      let(:product2) { Product.new(name: 'Strawberries', price: 5.00, code: 'SR1') }

      it 'raises UnsupportedProductError' do
        expect { pricing_rule.call(product: product2, quantity: 2) }
          .to raise_error(PricingRule::UnsupportedProductError)
      end
    end
  end
end
