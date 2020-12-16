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
end
