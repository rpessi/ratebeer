require 'rails_helper'

include Helpers

describe "Rating", :with_cache do
  include_context "with cache"
  let!(:brewery) { FactoryBot.create :brewery, name: "Koff" }
  let!(:brewery2) { FactoryBot.create :brewery, name: "Laitila" }
  let!(:brewery3) { FactoryBot.create :brewery, name: "Olvi" }
  let!(:beer1) { FactoryBot.create :beer, name: "Iso 3", brewery:brewery }
  let!(:beer2) { FactoryBot.create :beer, name: "Karhu", brewery:brewery }
  let!(:beer3) { FactoryBot.create :beer, name: "Kukko", brewery:brewery2 }
  let!(:beer4) { FactoryBot.create :beer, name: "Kana", brewery:brewery2 }
  let!(:beer5) { FactoryBot.create :beer, name: "NEIPA", brewery:brewery3 }
  let!(:beer6) { FactoryBot.create :beer, name: "Tuplapukki", brewery:brewery3 }
  let!(:user) { FactoryBot.create :user }

  before :each do
    sign_in(username: "Pekka", password: "Foobar1")
  end

  it "when given, is registered to the beer and user who is signed in" do
    visit new_rating_path
    select('Iso 3', from: 'rating[beer_id]')
    fill_in('rating[score]', with: '15')

    expect_any_instance_of(RatingsController).to receive(:expire_brewery_cache)
    expect_any_instance_of(RatingsController).to receive(:expire_beer_cache)
    expect{
      click_button "Create Rating"
    }.to change{Rating.count}.from(0).to(1)

    expect(user.ratings.count).to eq(1)
    expect(beer1.ratings.count).to eq(1)
    expect(beer1.average_rating).to eq(15.0)
  end

  it "will not accept a rating with invalid number", :with_cache do
    visit new_rating_path
    select('Iso 3', from: 'rating[beer_id]')
    fill_in('rating[score]', with: '-5')
    expect{
      click_button "Create Rating"
    }.to_not change{Rating.count}
    expect(page).to have_content "Rating must be an integer in range of 1-50."
  end

  it "caches the last ratings", :with_cache do
    expect(Rails.cache.exist?("last_ratings")).to be false
    visit ratings_path
    expect(Rails.cache.exist?("last_ratings")).to be true
  end

  it "caches the top breweries", :with_cache do
    expect(Rails.cache.exist?("top_breweries")).to be false
    visit ratings_path
    expect(Rails.cache.exist?("top_breweries")).to be true
  end

  it "caches the top beers", :with_cache do
    expect(Rails.cache.exist?("top_beers")).to be false
    visit ratings_path
    expect(Rails.cache.exist?("top_beers")).to be true
  end

  it "will show the latest ratings" do
    create_beers_with_many_ratings({user: user}, 10, 20, 15, 7, 9)
    visit ratings_path

    expect(page).to have_content "Factory Beer 9"
    expect(page).to have_content "Factory Beer 15"
    expect(page).to have_content "Factory Beer 10"
  end

  it "will show three best rated beers" do
    create_beers_with_many_ratings({user: user}, 10, 20, 15, 7, 9)
    visit ratings_path

    expect(page).to have_content "Best beers"
    expect(page).to have_content "Factory Beer"
    expect(page).to have_content "20.0"
    expect(page).to have_content "10.0"
    expect(page).to_not have_content "9.0"
  end

  it "will show three best rated breweries" do
    scores = [10, 15, 20, 25, 30, 35]
    beers = [beer1, beer2, beer3, beer4, beer5, beer6]
    beers.zip(scores).each do |beer, score|
      FactoryBot.create(:rating, score: score, beer: beer, user: user)
    end
    visit ratings_path

    expect(page).to have_content "Koff"
    expect(page).to have_content "12.5"
    expect(page).to have_content "Laitila"
    expect(page).to have_content "22.5"
    expect(page).to have_content "Olvi"
    expect(page).to have_content "32.5"
  end

  it "will show the ratings given by the user on user's page" do
    visit new_rating_path
    select('Iso 3', from: 'rating[beer_id]')
    fill_in('rating[score]', with: '15')
    click_button "Create Rating"

    expect(page).to have_content "#{user.username} has made 1 rating"
    expect(page).to have_content "Iso 3 15"

    visit new_rating_path
    select('Karhu', from: 'rating[beer_id]')
    fill_in('rating[score]', with: '18')
    click_button "Create Rating"

    expect(page).to have_content "#{user.username} has made 2 ratings"
    expect(page).to have_content "Karhu 18"
  end

  it "will delete the rating upon user's request" do
    visit new_rating_path
    select('Iso 3', from: 'rating[beer_id]')
    fill_in('rating[score]', with: '15')

    expect{
      click_button "Create Rating"
    }.to change{Rating.count}.from(0).to(1)

    visit new_rating_path
    select('Karhu', from: 'rating[beer_id]')
    fill_in('rating[score]', with: '18')
    click_button "Create Rating"

    expect{
      within("li", text: 'Iso 3 15') do 
        click_link 'Delete'
      end
    }.to change{Rating.count}.from(2).to(1)

    expect_any_instance_of(RatingsController).to receive(:expire_brewery_cache)
    expect_any_instance_of(RatingsController).to receive(:expire_beer_cache)
    expect{
      within("li", text: 'Karhu 18') do 
        click_link 'Delete'
      end
    }.to change{Rating.count}.from(1).to(0)
  end
end
