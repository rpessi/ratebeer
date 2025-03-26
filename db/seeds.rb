# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# b1 = Brewery.create name: "Koff", year: 1897
# b2 = Brewery.create name: "Malmgard", year: 2001
# b3 = Brewery.create name: "Weihenstephaner", year: 1040

# b1.beers.create name: "Iso 3", style: "Lager"
# b1.beers.create name: "Karhu", style: "Lager"
#b1.beers.create name: "Tuplahumala", style: "Lager"
#b2.beers.create name: "Huvila Pale Ale", style: "Pale Ale"
#b2.beers.create name: "X Porter", style: "Porter"
#b3.beers.create name: "Hefeweizen", style: "Weizen"
#b3.beers.create name: "Helles", style: "Lager"

# Create some users
users = [
  { username: "Jaakko" },
  { username: "Pekka" },
  { username: "Teppo" }
].map { |user| User.find_or_create_by(user) }

# Create some breweries
breweries = [
  { name: "BrewDog", year: 2007 },
  { name: "Weihenstephan", year: 1040 },
  { name: "Sierra Nevada", year: 1980 }
].map { |brewery| Brewery.find_or_create_by(brewery) }

# Create some beers
beers = [
  { name: "Punk IPA", style: "IPA", brewery_id: breweries[0].id },
  { name: "Hefeweizen", style: "Weizen", brewery_id: breweries[1].id },
  { name: "Pale Ale", style: "Pale Ale", brewery_id: breweries[2].id }
].map { |beer| Beer.find_or_create_by(beer) }

# Create some ratings
[
  { score: 15, beer: beers[0], user_id: users[0].id },
  { score: 14, beer: beers[0], user_id: users[1].id },
  { score: 13, beer: beers[1], user_id: users[1].id },
  { score: 14, beer: beers[2], user_id: users[2].id },
  { score: 12, beer: beers[2], user_id: users[0].id }
].each { |rating| Rating.find_or_create_by(rating) }

puts "Seed data created successfully!"