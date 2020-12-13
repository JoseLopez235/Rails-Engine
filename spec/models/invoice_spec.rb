require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe "Validations" do
    it {should validate_presence_of(:merchant_id)}
    it {should validate_presence_of(:customer_id)}
  end

  describe "Relationships" do
    it {should belong_to(:merchant)}
    it {should belong_to(:customer)}
    it {should have_many(:invoice_items)}
    it {should have_many(:transactions)}
  end
end
