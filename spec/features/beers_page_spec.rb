require 'rails_helper'

include Helpers

describe "Beers page" do

  describe "with at least one brewery" do
    before :each do
      @style = FactoryBot.create :style
      @beer = FactoryBot.create(:beer, style: @style)
      @user = FactoryBot.create :user
    end

    it "allows a beer with a name to be added" do
      sign_in(username: "Pekka", password: "Foobar1")
      visit new_beer_path
      fill_in('beer_name', with: 'Tasty Lager' )
      select(@style.name)
      select(@beer.brewery.name)
      expect{
        click_button('Create Beer')
      }.to change{Beer.count}.by(1)
      expect(page).to have_content "Beer was successfully created."
    end

    it "will not allow a beer without a name to be added" do
      sign_in(username: "Pekka", password: "Foobar1")
      visit new_beer_path
      fill_in('beer_name', with: '' )
      select(@style.name)
      select(@beer.brewery.name)
      expect{
        click_button('Create Beer')
      }.to change{Beer.count}.by(0)
      expect(page).to have_content "Name can't be blank"
    end

    it "shows the rating average for a beer" do
      FactoryBot.create(:rating, beer: @beer, score: 10, user: @user)
      visit beer_path(@beer)
      expect(page).to have_content "Beer has 1 rating with an average of 10.0"

      FactoryBot.create(:rating, beer: @beer, score: 15, user: @user)
      visit beer_path(@beer)
      expect(page).to have_content "Beer has 2 ratings with an average of 12.5"
    end
  end
end
