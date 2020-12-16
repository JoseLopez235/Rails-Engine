require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe "Validations" do
    it {should validate_presence_of(:name)}
  end

  describe "Relationships" do
    it {should have_many(:invoices)}
    it {should have_many(:items)}
  end

  describe "Methods" do
    it ".all_items" do
      merchant = create(:merchant)
      item1 = create(:item, merchant_id: merchant.id)
      item2 = create(:item, merchant_id: merchant.id)
      create(:item)

      items = merchant.all_items

      expect(items.count).to eq(2)

      expect(items[0]).to eq(item1)
      expect(items[1]).to eq(item2)
    end

    it ".find_merchant" do
      create(:merchant, name: "Jose Lopez")
      create(:merchant, name: "Bob Joe")
      attribute = "name"
      value = "Jo"

      expect(Merchant.find_merchant(attribute, value).name).to eq("Jose Lopez")
    end

    it ".find_all_merchant" do
      create(:merchant, name: "Jose Lopez")
      create(:merchant, name: "Bob Joe")
      create(:merchant, name: "Lorraine Rodriguez")
      attribute = "name"
      value = "lo"
      merchants = Merchant.find_all_merchant(attribute, value)

      expect(merchants.count).to eq(2)
      expect(merchants[0].name).to eq("Jose Lopez")
      expect(merchants[1].name).to eq("Lorraine Rodriguez")
    end

    it ".merchants_revenue" do
      merchant1 = create(:merchant)
      merchant2 = create(:merchant)
      merchant3 = create(:merchant)
      customer = create(:customer)

      item1 = create(:item, merchant_id: merchant1.id)
      item2 = create(:item, merchant_id: merchant1.id)
      item3 = create(:item, merchant_id: merchant2.id)
      item4 = create(:item, merchant_id: merchant3.id)

      invoice1 = create(:invoice, customer_id: customer.id, merchant_id: merchant1.id)
      invoice2 = create(:invoice, customer_id: customer.id, merchant_id: merchant1.id)
      invoice3 = create(:invoice, customer_id: customer.id, merchant_id: merchant2.id)
      invoice4 = create(:invoice, customer_id: customer.id, merchant_id: merchant3.id)

      create(:transaction, invoice_id: invoice1.id, result: "success")
      create(:transaction, invoice_id: invoice2.id, result: "failed")
      create(:transaction, invoice_id: invoice3.id, result: "success")
      create(:transaction, invoice_id: invoice4.id, result: "failed")

      create(:invoice_item, item_id: item1.id, invoice_id: invoice1.id )
      create(:invoice_item, item_id: item2.id, invoice_id: invoice2.id )
      create(:invoice_item, item_id: item3.id, invoice_id: invoice3.id )
      create(:invoice_item, item_id: item4.id, invoice_id: invoice4.id )

      expect(Merchant.merchants_revenue(2)).to eq([merchant1, merchant2])
    end
  end
end
