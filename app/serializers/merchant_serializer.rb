class MerchantSerializer
  def self.format_merchants(merchants)
    all_data = {data: []}
    merchants.each do |merchant|
      all_data[:data] << {
        id: merchant.id,
        type: "merchant",
        attributes: {
          name: merchant.name,
        }
      }
    end
    all_data
  end

  def self.merchant_details(merchant)
    {
      data: {
        id: merchant.id,
        type: "merchant",
        attributes: {
          name: merchant.name
        }
      }
    }
  end
end
