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
      style = FactoryBot.create(:style, name: "Lager")
      beer1 = FactoryBot.create(:beer, name: "Test Beer1", style: style)
      beer2 = FactoryBot.create(:beer, name: "Test Beer2", style: style)
      FactoryBot.create(:rating, score: 20, beer: beer1, user: user)
      FactoryBot.create(:rating, score: 10, beer: beer2, user: user)

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

    it "is the one with highest rating if several rated" do #FAIL
      create_beers_with_many_ratings({ user: user }, 10, 20, 15, 7, 9)
      best = create_beer_with_rating({ user: user }, 25 )
    
      expect(user.favorite_beer).to eq(best)
    end
    #Failure/Error: FactoryBot.create(:rating, score: 20, user: user)
     
     # ActiveRecord::RecordInvalid:
     # Validation failed: Name has already been taken
    # ./spec/models/user_spec.rb:50:in `block (3 levels) in <top (required)>'
  end

  describe "favorite style" do
    let(:user){ FactoryBot.create(:user) }
    let(:s1){ FactoryBot.create(:style, name: "Lager") }
    let(:s2){ FactoryBot.create(:style, name: "IPA") }
    let(:s3){ FactoryBot.create(:style, name: "Weizen") }

    it "has method for determining one" do
      expect(user).to respond_to(:favorite_style)
    end

    it "without ratings does not have one" do
      expect(user.favorite_style).to eq(nil)
    end

    it "is the only rated if only one rating" do #FAIL
      beer = FactoryBot.create(:beer)
      FactoryBot.create(:rating, score: 20, beer: beer, user: user)

      expect(user.favorite_style).to eq(beer.style.name)
    end

    it "is the one with highest average rating" do
      beer1 = FactoryBot.create(:beer, name: "beer1", style: s1) 
      beer2 = FactoryBot.create(:beer, name: "beer2", style: s1)
      beer3 = FactoryBot.create(:beer, name: "beer3", style: s2)
      beer4 = FactoryBot.create(:beer, name: "beer4", style: s2)
      beer5 = FactoryBot.create(:beer, name: "beer5", style: s3)
      beer6 = FactoryBot.create(:beer, name: "beer6", style: s3)
      FactoryBot.create(:rating, score: 10, beer: beer1, user: user)
      FactoryBot.create(:rating, score: 15, beer: beer2, user: user)
      FactoryBot.create(:rating, score: 20, beer: beer3, user: user)
      FactoryBot.create(:rating, score: 15, beer: beer4, user: user)
      FactoryBot.create(:rating, score: 20, beer: beer5, user: user)
      FactoryBot.create(:rating, score: 16, beer: beer6, user: user)

      expect(user.favorite_style).to eq(beer5.style.name)
    end
  end

  describe "favorite brewery" do
    let(:user){ FactoryBot.create(:user) }
    let(:style){ FactoryBot.create(:style, name: "Lager") }

    it "has method for determining one" do
      expect(user).to respond_to(:favorite_brewery)
    end

    it "without ratings does not have one" do
      expect(user.favorite_brewery).to eq(nil)
    end

    it "is the only rated if only one rating" do
      create_beer_with_rating({ user: user }, 25 )
      expect(user.favorite_brewery).to eq(user.ratings.first.beer.brewery.name)
    end

    it "is the one with highest average rating" do  #FAIL
      brewery1 = FactoryBot.create(:brewery, name: "Koff")
      brewery2 = FactoryBot.create(:brewery, name: "Olvi")
      brewery3 = FactoryBot.create(:brewery, name: "Laitila")
      beer1 = Beer.create(name: "Koff1", style: style, brewery_id: brewery1.id)
      beer2 = Beer.create(name: "Koff2", style: style, brewery_id: brewery1.id)
      beer3 = Beer.create(name: "Olvi1", style: style, brewery_id: brewery2.id)
      beer4 = Beer.create(name: "Olvi2", style: style, brewery_id: brewery2.id)
      beer5 = Beer.create(name: "Laitila1", style: style, brewery_id: brewery3.id)
      beer6 = Beer.create(name: "Laitila2", style: style, brewery_id: brewery3.id)
      FactoryBot.create(:rating, score: 10, beer: beer1, user: user)
      FactoryBot.create(:rating, score: 15, beer: beer2, user: user)
      FactoryBot.create(:rating, score: 20, beer: beer3, user: user)
      FactoryBot.create(:rating, score: 15, beer: beer4, user: user)
      FactoryBot.create(:rating, score: 20, beer: beer5, user: user)
      FactoryBot.create(:rating, score: 20, beer: beer6, user: user)

      expect(user.favorite_brewery).to eq(beer5.brewery.name)
    end
  end
end
