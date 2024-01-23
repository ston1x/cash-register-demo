# frozen_string_literal: true

require_relative '../spec_helper'
RSpec.describe Product do
  describe '#initialize' do
    let(:product) { Product.new(name: 'Green Tea', price: 3.11, code: 'GR1') }

    it 'creates a new product with the provided attributes' do
      expect(product.name).to eq('Green Tea')
      expect(product.price).to eq(3.11)
      expect(product.code).to eq('GR1')
    end
  end
end
