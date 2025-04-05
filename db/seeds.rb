# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

b1 = Brewery.create name: "Koff", year: 1897
b2 = Brewery.create name: "Malmgard", year: 2001
b3 = Brewery.create name: "Weihenstephaner", year: 1040
s1 = Style.create name: "Weizen",
                  description: ""
s2 = Style.create name: "Lager",
                  description: ""
s3 = Style.create name: "Pale Ale",
                  description: ""
s4 = Style.create name: "IPA",
                  description: ""
s5 = Style.create name: "Porter",
                  description: ""
s6 = Style.create name: "Lowalcohol",
                  description: ""
b1.beers.create name: "Crisp Hoppy Lager", style_id: s6.id
b1.beers.create name: "Brooklyn Summer Ale", style_id: s3.id
b1.beers.create name: "Extra Light Triple Brewed", style: s2.id
b2.beers.create name: "Huvila Pale Ale", style_id: s3.id
b2.beers.create name: "X Porter", style_id: s5.id
b3.beers.create name: "Hefeweizen", style_id: s1.id
b3.beers.create name: "Helles", style_id: s2.id

