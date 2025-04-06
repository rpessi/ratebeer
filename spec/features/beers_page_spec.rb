require 'rails_helper'

include Helpers

describe "Beers page" do

  describe "with at least one brewery" do
    before :each do
      @beer = FactoryBot.create :beer
      FactoryBot.create :user
    end

    it "allows a beer with a name to be added" do
      sign_in(username: "Pekka", password: "Foobar1")
      visit new_beer_path
      fill_in('beer_name', with: 'Tasty Lager' )
      select(@beer.style)
      puts @beer.style
      select(@beer.brewery.name)
      puts@beer.brewery.name
      expect{
        click_button('Create Beer')
      }.to change{Beer.count}.by(1)
      expect(page).to have_content "Beer was successfully created."
    end

    it "will not allow a beer without a name to be added" do
      sign_in(username: "Pekka", password: "Foobar1")
      visit new_beer_path
      fill_in('beer_name', with: '' )
      select(@beer.style)
      select(@beer.brewery.name)
      expect{
        click_button('Create Beer')
      }.to change{Beer.count}.by(0)
      expect(page).to have_content "Name can't be blank"
    end
  end
end
