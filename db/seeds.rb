require 'csv'

cmd = "pg_restore --verbose --clean --no-acl --no-owner -h localhost -U $(whoami) -d rails-engine_development db/data/rails-engine-development.pgdump"
puts "Loading PostgreSQL Data dump into local database with command:"
puts cmd
system(cmd)

file = "./db/data/items.csv"
CSV.foreach(file, headers: true) do |row|
 data = row.to_hash
 if data["unit_price"]
   data["unit_price"] = (data["unit_price"].to_f / 100).round(2)
 end
 Item.create!(data)
end

ActiveRecord::Base.connection.tables.each do |t|
  ActiveRecord::Base.connection.reset_pk_sequence!(t)
end
