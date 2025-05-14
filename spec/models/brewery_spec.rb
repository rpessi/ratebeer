require 'rails_helper'

RSpec.describe Brewery, type: :model do
  
  it "is valid with a valid name and a valid year" do
    name = "New Brewery"
    year = 2020
    brewery = FactoryBot.create(:brewery, name: name, year: year, active: true)

    expect(brewery).to be_valid
    expect(brewery.name).to eq(name)
    expect(Brewery.active.count).to eq(1)
    expect(Brewery.retired.count).to eq(0)
  end

  it "raises an error if no year is given" do
    expect{
      FactoryBot.create(:brewery, year: '')
    }.to raise_error { |error|
      expect(error).to be_a(ActiveRecord::RecordInvalid)}
  end

  it "raises an error if year is in the future" do
    expect{
      FactoryBot.create(:brewery, year: 2100)
    }.to raise_error { |error|
      expect(error).to be_a(ActiveRecord::RecordInvalid)}
  end

  describe "with an existing brewery" do
    let!(:brewery) { FactoryBot.create :brewery }
    let!(:beer1) { FactoryBot.create :beer, name: "Iso 3", brewery: brewery }
    let!(:beer2) { FactoryBot.create :beer, name: "Karhu", brewery: brewery }
    let!(:user) { FactoryBot.create :user }
    let!(:rating1) { FactoryBot.create :rating, beer: beer1, score: 15, user: user }
    let!(:rating2) { FactoryBot.create :rating, beer: beer2, score: 20, user: user }
    let!(:brewery2) { FactoryBot.create :brewery, name: "Laitila" }
    let!(:beer3) { FactoryBot.create :beer, name: "Kukko", brewery:brewery2 }
    let!(:beer4) { FactoryBot.create :beer, name: "Kana", brewery:brewery2 }
    let!(:rating3) { FactoryBot.create :rating, beer: beer3, score: 25, user: user }
    let!(:rating4) { FactoryBot.create :rating, beer: beer4, score: 20, user: user }


    it "prints a report of basic information" do
      expect { 
        brewery.print_report
      }.to output("Factory Brewery\nEstablished at year 1900\nNumber of beers 2\n")
       .to_stdout
    end

    it "gives a rating summary" do
      expect(brewery.rating_summary).to eq("Brewery has 2 ratings\n    with an average of 17.5")
    end

    it "brewery can be restarted" do
      expect {
        brewery.restart
      }.to output("Changed year to 2022\n")
       .to_stdout
    end

    it "there is a method for ranking the breweries by ratings" do
      best =  Brewery.top(1)[0]
      expect(best.name).to eq("Laitila")
      expect(best.average_rating).to eq(22.5)
    end
  end
end