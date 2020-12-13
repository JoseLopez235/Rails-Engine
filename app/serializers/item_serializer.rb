class ItemSerializer
  def self.format_items(items)
    all_data = {data: []}
    items.each do |item|
      all_data[:data] << {
        id: item.id,
        type: "item",
        attributes: {
          name: item.name,
          description: item.description,
          unit_price: item.unit_price,
          merchant_id: item.merchant_id
        }
      }
    end
    all_data
  end

  def self.item_details(item)
    {
      data: {
        id: item.id,
        type: "item",
        attributes: {
          name: item.name,
          description: item.description,
          unit_price: item.unit_price,
          merchant_id: item.merchant_id
        }
      }
    }
  end
end
