class Merchant < ApplicationRecord
  validates_presence_of :name

  has_many :invoices
  has_many :items

  def all_items
    items.where(merchant_id: self.id)
  end

  def self.find_merchant(attribute, value)
    where("#{attribute} ILIKE ?", "%#{value}%").first
  end

  def self.find_all_merchant(attribute, value)
    where("#{attribute} ILIKE ?", "%#{value}%")
  end

  def self.merchants_revenue(quantity)
    select("merchants.*, SUM(invoice_items.quantity * invoice_items.unit_price) AS revenue")
    .joins(invoices: [:invoice_items, :transactions])
    .where(transactions: {result: "success"})
    .group(:id)
    .order("revenue DESC")
    .limit(quantity)
  end

  def self.most_item_sold(quantity)
    select("merchants.*, SUM(invoice_items.quantity) AS items_sold")
    .joins(invoices: [:invoice_items, :transactions])
    .where(transactions: {result: "success"})
    .group(:id)
    .order("items_sold DESC")
    .limit(quantity)
  end

  def self.revenue_range(start_date, end_date)
    joins(invoices: [:invoice_items, :transactions])
    .where(
      transactions: {result: 'success'},
      invoices: {created_at: (start_date)..("#{end_date} 23:59:59"), status: 'shipped'}
    )
    .sum('invoice_items.quantity * invoice_items.unit_price')
  end
end
