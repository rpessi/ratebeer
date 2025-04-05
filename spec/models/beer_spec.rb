require 'rails_helper'

RSpec.describe Beer, type: :model do
  # Copilot helper test to see if updated Factorybot works
  it "is valid with a name, style, and brewery" do
    style = FactoryBot.create(:style)
    brewery = FactoryBot.create(:brewery)
    beer = FactoryBot.create(:beer, style: style, brewery: brewery)

    expect(beer).to be_valid
    expect(beer.style).to eq(style)
    expect(beer.brewery).to eq(brewery)
  end
  # Copilot helper test to see if updated Factorybot works
  it "is invalid without a style" do
    brewery = FactoryBot.create(:brewery)
    beer = FactoryBot.build(:beer, style: nil, brewery: brewery)

    expect(beer).not_to be_valid
  end

  it "has the name set correctly" do
    beer = Beer.new name: "Hefeweisse"

    expect(beer.name).to eq("Hefeweisse")
  end

  it "has the style set correctly" do
    beer = Beer.new style_id: 1

    expect(beer.style_id).to eq(1)
  end

  describe "with existing parent brewery and parent style" do
    let(:test_brewery) { Brewery.new name: "test", year: 2000, id: 1 }
    let(:test_style) { Style.new name: "anonymous", description: "tasty", id: 5}

    it "is saved when name, style_id and brewery_id are given" do
      beer = Beer.create name: "Hefeweisse", style: test_style, brewery: test_brewery

      expect(beer).to be_valid
      expect(Beer.count).to eq(1)
    end

    it "is not saved, if name is not given" do
      beer = Beer.create style: test_style, brewery: test_brewery

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
