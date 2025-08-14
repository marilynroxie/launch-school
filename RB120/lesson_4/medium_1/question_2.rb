class InvoiceEntry
  attr_reader :quantity, :product_name

  def initialize(product_name, number_purchased)
    @quantity = number_purchased
    @product_name = product_name
  end

  def update_quantity(updated_count)
    # prevent negative quantities from being set
    @quantity = updated_count if updated_count >= 0
  end
end

my_invoice = InvoiceEntry.new("cards", 10)

p my_invoice
my_invoice.update_quantity(15)
p my_invoice
