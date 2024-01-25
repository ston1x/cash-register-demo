# frozen_string_literal: true

require_relative '../spec_helper'
RSpec.describe 'Receipt' do
  let(:product) { Product.new(name: 'Green tea', price: 3.11, code: 'GR1') }
  let(:line_item) { Checkout::LineItem.new(product:, quantity: 2, total_price: 6.22, price_with_discount: 6.22) }
  let(:line_items) { [line_item] }
  let(:total) { 6.22 }
  let(:total_with_discount) { 6.22 }

  describe '#initialize' do
    it 'initializes a receipt with line_items, total, total_with_discount' do
      receipt = Receipt.new(line_items:, total:, total_with_discount:)
      expect(receipt.line_items).to eq(line_items)
      expect(receipt.total).to eq(total)
      expect(receipt.total_with_discount).to eq(total_with_discount)
    end
  end

  describe '#print' do
    it 'prints the receipt' do
      expect do
        Receipt.new(line_items:, total:, total_with_discount:).print
      end.to output(
        "[GR1] Green tea       x2 - 6.22  (6.22)\n"\
        "Total: 6.22\n"\
        "Total (after discounts): 6.22\n"
      ).to_stdout
    end
  end
end
