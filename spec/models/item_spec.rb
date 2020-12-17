require 'rails_helper'

RSpec.describe Item, type: :model do
  describe "Validations" do
    it {should validate_presence_of(:name)}
    it {should validate_presence_of(:description)}
    it {should validate_presence_of(:unit_price)}
    it {should validate_presence_of(:merchant_id)}
  end

  describe "Relationships" do
    it {should belong_to(:merchant)}

    it {should have_many(:invoice_items)}
  end

  describe "Methods" do
    it ".find_item" do
      create(:item, name: "Stuff Bear", description: "Fluffy and Cute")
      create(:item, name: "Toy Car", description: "Red Color with stripes")
      create(:item, name: "Stuff Lion", description: "Cute")
      create(:item, name: 'Princess Doll', description: "Cute and pretty")
      attribute = "name"
      value = "toy"

      expect(Item.find_item(attribute, value).name).to eq("Toy Car")
    end

    it ".find_all_item" do
      create(:item, name: "Stuff Bear", description: "Fluffy and Cute")
      create(:item, name: "Toy Car", description: "Red Color with stripes")
      create(:item, name: "Stuff Lion", description: "Cute")
      create(:item, name: 'Princess Doll', description: "Cute and pretty")
      attribute = "description"
      value = "cute"
      items = Item.find_all_item(attribute, value)

      expect(items.count).to eq(3)

      expect(items[0].name).to eq("Stuff Bear")
      expect(items[1].name).to eq("Stuff Lion")
      expect(items[2].name).to eq("Princess Doll")
    end
  end
end
