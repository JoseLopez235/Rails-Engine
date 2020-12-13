class Invoice < ApplicationRecord
  validates_presence_of :merchant_id, :customer_id

  belongs_to :merchant
  belongs_to :customer

  has_many :invoice_items
  has_many :transactions
end
