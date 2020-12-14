class Merchant < ApplicationRecord
  validates_presence_of :name

  has_many :invoices
  has_many :items


  def all_items
    items.where(merchant_id: self.id)
  end
end
