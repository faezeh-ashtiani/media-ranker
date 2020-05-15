# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'csv'

WORK_FILE = Rails.root.join('db', 'works-seed.csv')
puts "Loading raw work data from #{WORK_FILE}"

work_failures = []
CSV.foreach(WORK_FILE, :headers => true) do |row|
  work = Work.new
  work.id = row['id']
  work.name = row['name']
  work.vin = row['vin']
  work.available = row['available']
  successful = work.save
  if !successful
    work_failures << work
    puts "Failed to save work: #{work.inspect}"
  else
    puts "Created work: #{work.inspect}"
  end
end

puts "Added #{Work.count} work records"
puts "#{work_failures.length} works failed to save"



PASSENGER_FILE = Rails.root.join('db', 'seed_data', 'passengers.csv')
puts "Loading raw passenger data from #{PASSENGER_FILE}"

passenger_failures = []
CSV.foreach(PASSENGER_FILE, :headers => true) do |row|
  passenger = Passenger.new
  passenger.category = row['category']
  passenger.title = row['title']
  passenger.creator = row['creator']
  passenger.publication_year = row['publication_year']
  passenger.description = row['description']
  successful = passenger.save
  if !successful
    passenger_failures << passenger
    puts "Failed to save passenger: #{passenger.inspect}"
  else
    puts "Created passenger: #{passenger.inspect}"
  end
end

puts "Added #{Passenger.count} passenger records"
puts "#{passenger_failures.length} passengers failed to save"

# Since we set the primary key (the ID) manually on each of the
# tables, we've got to tell postgres to reload the latest ID
# values. Otherwise when we create a new record it will try
# to start at ID 1, which will be a conflict.
puts "Manually resetting PK sequence on each table"
ActiveRecord::Base.connection.tables.each do |t|
  ActiveRecord::Base.connection.reset_pk_sequence!(t)
end

puts "done"
