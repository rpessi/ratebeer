require 'rails_helper'

include Helpers

RSpec.describe User, type: :model do
  it "has the username set correctly" do
    user = User.new username: "Pekka"

    expect(user.username).to eq("Pekka")
  end

  it "is not saved without a password" do
    user = User.create username: "Pekka"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  it "is not saved if the password is shorter than 4 characters" do
    user = User.create username: "Pekka", password: "Se1", password_confirmation: "Se1"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  it "is not saved if the password does not include capital letters" do
    user = User.create username: "Pekka", password: "secret1", password_confirmation: "secret1"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  it "is not saved if the password does not include numbers" do
    user = User.create username: "Pekka", password: "Secret$", password_confirmation: "Secret$"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  describe "with a proper password" do
    let(:user) { FactoryBot.create(:user) }

    it "is saved" do
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end

    it "and two ratings, has the correct average rating" do
      FactoryBot.create(:rating, score: 10, user: user)
      FactoryBot.create(:rating, score: 20, user: user)
    
      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)
    end
  end

  describe "favorite beer" do
    let(:user){ FactoryBot.create(:user) }

    it "has method for determining one" do
      expect(user).to respond_to(:favorite_beer)
    end

    it "without ratings does not have one" do
      expect(user.favorite_beer).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = FactoryBot.create(:beer)
      FactoryBot.create(:rating, score: 20, beer: beer, user: user)
    
      expect(user.favorite_beer).to eq(beer)
    end

    it "is the one with highest rating if several rated" do
      create_beers_with_many_ratings({user: user}, 10, 20, 15, 7, 9)
      best = create_beer_with_rating({ user: user }, 25 )
    
      expect(user.favorite_beer).to eq(best)
    end
  end

  describe "favorite style" do
    let(:user){ FactoryBot.create(:user) }

    it "has method for determining one" do
      expect(user).to respond_to(:favorite_style)
    end

    it "without ratings does not have one" do
      expect(user.favorite_style).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = FactoryBot.create(:beer)
      FactoryBot.create(:rating, score: 20, beer: beer, user: user)

      expect(user.favorite_style).to eq(beer.style)
    end

    it "is the one with highest average rating" do
      beer1 = FactoryBot.create(:beer) # style: "Lager"
      beer2 = FactoryBot.create(:beer, style: "IPA")
      beer3 = FactoryBot.create(:beer, name: "beer3", style: "IPA")
      beer4 = FactoryBot.create(:beer, name: "beer4", style: "LAGER")
      beer5 = FactoryBot.create(:beer, name: "beer5", style: "Weizen")
      beer6 = FactoryBot.create(:beer, name: "beer6", style: "Weizen")
      FactoryBot.create(:rating, score: 10, beer: beer1, user: user)
      FactoryBot.create(:rating, score: 15, beer: beer2, user: user)
      FactoryBot.create(:rating, score: 20, beer: beer3, user: user)
      FactoryBot.create(:rating, score: 15, beer: beer4, user: user)
      FactoryBot.create(:rating, score: 20, beer: beer5, user: user)
      FactoryBot.create(:rating, score: 20, beer: beer6, user: user)

      expect(user.favorite_style).to eq(beer5.style)
    end
  end
end
