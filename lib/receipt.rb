# frozen_string_literal: true

# Purpose: Print receipt for the checkout. Can be extended with various formats
# of output.
class Receipt
  def initialize(line_items:, total:, total_with_discount:)
    @line_items = line_items
    @total = total
    @total_with_discount = total_with_discount
  end

  attr_reader :line_items, :total, :total_with_discount

  def print
    line_items.each do |line_item|
      product = line_item.product
      puts formatted_line_item(product, line_item)
    end

    puts "Total: #{total.to_f}"
    puts "Total (after discounts): #{total_with_discount.to_f}"
  end

  def formatted_line_item(product, line_item)
    "[#{product.code}] #{product.name.ljust(15)} x#{line_item.quantity} "\
      "- #{line_item.total_price.to_f.to_s.ljust(5)} (#{line_item.price_with_discount.to_f})"
  end
end
