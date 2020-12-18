class Invoice < ApplicationRecord
  validates_presence_of :merchant_id, :customer_id

  belongs_to :merchant
  belongs_to :customer

  has_many :invoice_items
  has_many :transactions

  scope :parameters, -> (start_date, end_date) { where(invoices: {created_at: (start_date)..("#{end_date} 23:59:59"), status: 'shipped'}) }
end
