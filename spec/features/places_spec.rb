require 'rails_helper'

describe "Places" do
  it "if one is returned by the API, it is shown at the page" do
    allow(BeermappingApi).to receive(:places_in).with("Kumpula").and_return(
      [ Place.new( name: "Oljenkorsi", id: 1 ) ]
    )

    visit places_path
    fill_in('city', with: 'Kumpula')
    click_button "Search"

    expect(page).to have_content "Oljenkorsi"
  end

  it "if several are returned by the API, they are all shown at the page" do
    allow(BeermappingApi).to receive(:places_in).with("Kallio").and_return(
      [ Place.new( name: "Roskapankki", id: 2 ),
        Place.new( name: "Karhu Pub", id: 3 ),
        Place.new( name: "Wanha Apteekki", id: 4 ) ]
    )

    visit places_path
    fill_in('city', with: 'Kallio')
    click_button "Search"

    expect(page).to have_content "Roskapankki"
    expect(page).to have_content "Karhu Pub"
    expect(page).to have_content "Wanha Apteekki"
  end

  it "if no places are found, there will be a notice" do
    city = "Kuusisaari"
    allow(BeermappingApi).to receive(:places_in).with(city).and_return(
      []
    )

    visit places_path
    fill_in('city', with: city)
    click_button "Search"

    expect(page).to have_content "No locations in #{city}"
  end
end
