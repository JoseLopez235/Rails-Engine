class Item < ApplicationRecord
  validates_presence_of :name, :description, :unit_price, :merchant_id

  belongs_to :merchant

  has_many :invoice_items

  def self.find_item(attribute, value)
    where("#{attribute} ILIKE ?", "%#{value}%").first
  end

  def self.find_all_item(attribute, value)
    where("#{attribute} ILIKE ?", "%#{value}%")
  end
end
