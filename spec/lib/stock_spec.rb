# frozen_string_literal: true

require_relative '../spec_helper'
RSpec.describe Stock do
  let(:products) do
    [
      Product.new(name: 'Green tea', price: 3.11, code: 'GR1'),
      Product.new(name: 'Strawberries', price: 5.00, code: 'SR1'),
      Product.new(name: 'Coffee', price: 11.23, code: 'CF1')
    ]
  end
  let(:pricing_rules) do
    [
      PricingRules::BuyGetFree.new(product_codes: ['GR1'], options: { buy: 1, get: 1 }),
      PricingRules::PriceDiscount.new(product_codes: ['SR1'], options: { min_quantity: 3, new_price: 4.50 }),
      PricingRules::FractionDiscount.new(product_codes: ['CF1'], options: { min_quantity: 3, discount: 2.0 / 3.0 })
    ]
  end

  describe '#initialize' do
    let(:stock) { Stock.new(products:, pricing_rules:) }

    it 'creates a new stock with the provided products' do
      expect(stock.products).to eq(products)
    end
  end

  describe '#find_product' do
    let(:products) do
      [
        Product.new(name: 'Green tea', price: 3.11, code: 'GR1'),
        Product.new(name: 'Strawberries', price: 5.00, code: 'SR1'),
        Product.new(name: 'Coffee', price: 11.23, code: 'CF1')
      ]
    end

    let(:stock) { Stock.new(products:, pricing_rules:) }

    context 'when the product exists' do
      it 'returns the product' do
        expect(stock.find_product(code: 'GR1')).to eq(products.first)
      end
    end

    context 'when the product does not exist' do
      it 'raises ProductNotRegisteredError' do
        expect { stock.find_product(code: 'XX1') }.to raise_error(described_class::ProductNotRegisteredError)
      end
    end
  end

  describe '#add_product' do
    let(:stock) { Stock.new(products:, pricing_rules:) }
    let(:product) { Product.new(name: 'Milk', price: 1.00, code: 'MK1') }

    it 'adds the product to the stock' do
      expect { stock.add_product(product) }.to change { stock.products.size }.by(1)
    end
  end

  describe '#remove_product' do
    let(:stock) { Stock.new(products:, pricing_rules:) }
    let(:product) { Product.new(name: 'Milk', price: 1.00, code: 'MK1') }

    it 'removes the product from the stock' do
      stock.add_product(product)
      expect { stock.remove_product(code: product.code) }.to change { stock.products.size }.by(-1)
    end
  end
end
