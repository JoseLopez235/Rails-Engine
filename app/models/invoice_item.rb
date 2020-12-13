class InvoiceItem < ApplicationRecord
  validates_presence_of :item_id, :invoice_id, :quantity, :unit_price

  belongs_to :item
  belongs_to :invoice
end
