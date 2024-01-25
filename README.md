# Cash Register demo
This is a simple Cash Register CLI application that allows setting up a stock of registered products and pricing rules, filling up a cart, scanning its items, applying discounts based on pricing rules, then printing a receipt.

## Features
- Scan products and calculate the total price
- Apply discounts based on predefined pricing rules
- Print a receipt with detailed information about the purchased items and discounts

## Project Structure
The project is organized into the following files:
- `demo.rb`: An example of usage
- `checkout.rb`: Entry point for the Cash Register application, responsible for processing the cart and generating a receipt
- `stock.rb`: Represents the available stock of registered products
- `product.rb`: Defines the Product class with attributes like name, price, and code
- `pricing_rule.rb`: Base class for pricing rules
- `pricing_rules/`: Directory containing specific pricing rule implementations
- `receipt.rb`: Generates and prints the receipt based on the scanned items and calculated prices.

## Getting Started

To run the Cash Register, ensure you have Ruby installed on your system.
According to the [.ruby-version file](https://github.com/ston1x/cash-register-demo/blob/main/.ruby-version), you'd need Ruby 3.3.0 or newer.

Clone the repository:

```bash
git clone https://github.com/ston1x/cash-register-demo.git

# Navigate to the project directory
cd cash-register-demo
```

Run bundle:

```bash
bundle
```

Check out [demo.rb](https://github.com/ston1x/cash-register-demo/blob/main/demo.rb) for a usage example, and try running it:

```bash
ruby demo.rb
```

## Things left out of scope
There are several things left out of scope since they weren't mentioned in the assignment, and for the sake of simplicity:

- Accepting and processing payments.
- Handling only available amounts of items in stock
- Generating a receipt in other formats: PDF, CSV, JSON etc.

## Testing
The project uses RSpec for testing. To run the tests:

```bash
bundle exec rspec
```

## Contributing
Feel free to contribute to this project by submitting issues or pull requests.
