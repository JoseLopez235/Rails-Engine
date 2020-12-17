require 'rails_helper'

describe "Merchants API" do
  it "sends a list of merchants" do
    create_list(:merchant, 3)

    get '/api/v1/merchants'

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants[:data].count).to eq(3)

    merchants[:data].each do |merchant|
      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_an(String)

      expect(merchant).to have_key(:type)
      expect(merchant[:type]).to be_a(String)

      expect(merchant).to have_key(:attributes)
      expect(merchant[:attributes]).to be_a(Hash)

      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes][:name]).to be_a(String)
    end
  end

  it "can get one merchant by its id" do
    id = create(:merchant).id

    get "/api/v1/merchants/#{id}"

    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful

    merchant = merchant[:data]

    expect(merchant).to have_key(:id)
    expect(merchant[:id]).to eq("#{id}")

    expect(merchant).to have_key(:type)
    expect(merchant[:type]).to eq("merchant")

    expect(merchant).to have_key(:attributes)
    expect(merchant[:attributes]).to be_a(Hash)

    merchant = merchant[:attributes]

    expect(merchant).to have_key(:name)
    expect(merchant[:name]).to be_a(String)
  end

  it "can create a new merchant" do
    merchant_params = ({
                    name: 'Jose Lopez'
                  })
    headers = {"CONTENT_TYPE" => "application/json"}

    post "/api/v1/merchants", headers: headers, params: JSON.generate(merchant: merchant_params)
    created_merchant = Merchant.last

    expect(response).to be_successful

    expect(created_merchant.name).to eq(merchant_params[:name])
  end

  it "can update an existing merchant" do
    id = create(:merchant).id
    previous_name = Merchant.last.name
    merchant_params = { name: "Bob Marley" }
    headers = {"CONTENT_TYPE" => "application/json"}

    patch "/api/v1/merchants/#{id}", headers: headers, params: JSON.generate({merchant: merchant_params})
    merchant = Merchant.find_by(id: id)

    expect(response).to be_successful
    expect(merchant.name).to_not eq(previous_name)
    expect(merchant.name).to eq("Bob Marley")
  end

  it "can destroy an merchant" do
    merchant = create(:merchant)

    expect(Merchant.count).to eq(1)

    expect{ delete "/api/v1/merchants/#{merchant.id}" }.to change(Merchant, :count).by(-1)

    delete "/api/v1/merchants/#{merchant.id}"

    expect(response).to be_successful

    expect(Merchant.count).to eq(0)
    expect{Merchant.find(merchant.id)}.to raise_error(ActiveRecord::RecordNotFound)
  end

  describe "Relationships" do
    it "returns all items accociated with the merchant" do
      merchant = create(:merchant)
      create_list(:item, 3, merchant_id: merchant.id)

      get "/api/v1/merchants/#{merchant.id}/items"

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)

      expect(items[:data].count).to eq(3)

      items[:data].each do |item|
        expect(item).to have_key(:id)
        expect(item[:id]).to be_an(String)

        expect(item).to have_key(:type)
        expect(item[:type]).to be_a(String)

        expect(item).to have_key(:attributes)
        expect(item[:attributes]).to be_a(Hash)

        expect(item[:attributes]).to have_key(:name)
        expect(item[:attributes][:name]).to be_a(String)

        expect(item[:attributes]).to have_key(:description)
        expect(item[:attributes][:description]).to be_a(String)

        expect(item[:attributes]).to have_key(:unit_price)
        expect(item[:attributes][:unit_price]).to be_a(Float)

        expect(item[:attributes]).to have_key(:merchant_id)
        expect(item[:attributes][:merchant_id]).to be_a(Integer)
      end
    end
  end
  describe "Find Endpoints" do
    it "should find one merchant with the corresponding value" do
      merchant = create(:merchant, name: "Jose Lopez")
      create(:merchant, name: "Bob Joe")
      attribute = "name"
      value = "Jo"

      get "/api/v1/merchants/find?#{attribute}=#{value}"

      expect(response).to be_successful

      json = JSON.parse(response.body, symbolize_names: true)

      expect(merchant.name).to eq(json[:data][:attributes][:name])
    end

    it "should find all merchants that correspond with the value" do
      create(:merchant, name: "Jose Lopez")
      create(:merchant, name: "Bob Joe")
      create(:merchant, name: "Lorraine Rodriguez")
      attribute = "name"
      value = "lo"

      get "/api/v1/merchants/find_all?#{attribute}=#{value}"

      expect(response).to be_successful

      json = JSON.parse(response.body, symbolize_names: true)

      merchants = json[:data]

      expect(merchants.count).to eq(2)

      expect(merchants[0][:attributes][:name]).to eq("Jose Lopez")

      expect(merchants[1][:attributes][:name]).to eq("Lorraine Rodriguez")
    end
  end

  describe "Business Intelligence Endpoints" do
    it "should return merchants with most revenue" do
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

      get "/api/v1/merchants/most_revenue?quantity=#{2}"

      expect(response).to be_successful

      json = JSON.parse(response.body, symbolize_names: true)

      merchants = json[:data]

      expect(merchants.count).to eq(2)

      expect(merchants[0][:attributes][:name]).to eq(merchant1.name)
      expect(merchants[1][:attributes][:name]).to eq(merchant2.name)
    end

    it "should return merchants with most items sold" do
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
      create(:transaction, invoice_id: invoice2.id, result: "success")
      create(:transaction, invoice_id: invoice3.id, result: "failed")
      create(:transaction, invoice_id: invoice4.id, result: "success")

      create(:invoice_item, item_id: item1.id, invoice_id: invoice1.id )
      create(:invoice_item, item_id: item2.id, invoice_id: invoice2.id )
      create(:invoice_item, item_id: item3.id, invoice_id: invoice3.id )
      create(:invoice_item, item_id: item4.id, invoice_id: invoice4.id )

       get "/api/v1/merchants/most_items?quantity=#{2}"

       expect(response).to be_successful

       json = JSON.parse(response.body, symbolize_names: true)

       merchants = json[:data]

       expect(merchants.count).to eq(2)

       expect(merchants[0][:attributes][:name]).to eq(merchant1.name)
       expect(merchants[1][:attributes][:name]).to eq(merchant3.name)
    end

    it "should get revenue across date range" do
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

      create(:transaction, invoice_id: invoice1.id, result: "success", created_at: "2012-03-05")
      create(:transaction, invoice_id: invoice2.id, result: "success", created_at: "2012-08-08")
      create(:transaction, invoice_id: invoice3.id, result: "success", created_at: "2012-08-05")
      create(:transaction, invoice_id: invoice4.id, result: "failed", created_at: "2012-10-04")

      create(:invoice_item, item_id: item1.id, invoice_id: invoice1.id )
      create(:invoice_item, item_id: item2.id, invoice_id: invoice2.id )
      create(:invoice_item, item_id: item3.id, invoice_id: invoice3.id )
      create(:invoice_item, item_id: item4.id, invoice_id: invoice4.id )

      get "/api/v1/revenue?start=2012-03-01&end=2012-10-24"

      expect(response).to be_successful

      json = JSON.parse(response.body, symbolize_names: true)

      merchants = json[:data]
    end
  end
end
