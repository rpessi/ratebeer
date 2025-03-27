require 'rails_helper'

RSpec.describe Beer, type: :model do
  it "has the name set correctly" do
    beer = Beer.new name: "Hefeweisse"

    expect(beer.name).to eq("Hefeweisse")
  end

  it "has the style set correctly" do
    beer = Beer.new style: "Weizen"

    expect(beer.style).to eq("Weizen")
  end

  describe "with existing parent brewery" do
    let(:test_brewery) { Brewery.new name: "test", year: 2000, id: 1 }

    it "is saved when name, style and brewery_id given" do
      beer = Beer.create name: "Hefeweisse", style: "Weizen", brewery: test_brewery

      expect(beer).to be_valid
      expect(Beer.count).to eq(1)
    end

    it "is not saved, if name is not given" do
      beer = Beer.create style: "Weizen", brewery: test_brewery

      expect(beer).not_to be_valid
      expect(Beer.count).to eq(0)
    end

    it "is not saved, if style is not given" do
      beer = Beer.create name: "Hefeweisse", brewery: test_brewery

      expect(beer).not_to be_valid
      expect(Beer.count).to eq(0)
    end
  end
end


# oluen luonti onnistuu ja olut tallettuu kantaan jos oluella on nimi, tyyli ja panimo asetettuna
# oluen luonti ei onnistu (eli creatella ei synny validia oliota), jos sille ei anneta nimeä
# oluen luonti ei onnistu, jos sille ei määritellä tyyliä
