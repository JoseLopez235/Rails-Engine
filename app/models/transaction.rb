class Transaction < ApplicationRecord
  validates_presence_of :invoice_id, :credit_card_number, :credit_card_date, :result

  belongs_to :invoice

  scope :successful, -> { where(result: 'success') }
end
