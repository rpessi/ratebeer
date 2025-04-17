require 'rails_helper'

include Helpers

describe "Beers page" do

  describe "with at least one brewery" do
    before :each do
      @style = FactoryBot.create :style
      @beer = FactoryBot.create(:beer, style: @style)
      @user = FactoryBot.create :user
    end

    it "shows the rating average for a beer" do
      FactoryBot.create(:rating, beer: @beer, score: 10, user: @user)
      visit beer_path(@beer)
      expect(page).to have_content "Beer has 1 rating with an average of 10.0"

      FactoryBot.create(:rating, beer: @beer, score: 15, user: @user)
      visit beer_path(@beer)
      expect(page).to have_content "Beer has 2 ratings with an average of 12.5"
    end

    describe "for a signed in user" do
      before :each do
        sign_in(username: "Pekka", password: "Foobar1")
      end

      it "allows a beer with a name to be added" do
        visit new_beer_path
        fill_in('beer_name', with: 'Tasty Lager' )
        select(@style.name)
        select(@beer.brewery.name)
        expect_any_instance_of(BeersController).to receive(:expire_brewery_cache)
        expect_any_instance_of(BeersController).to receive(:expire_beer_cache)
        expect{
          click_button('Create Beer')
        }.to change{Beer.count}.by(1)
        expect(page).to have_content "Beer was successfully created."
      end
  
      it "will not allow a beer without a name to be added" do
        visit new_beer_path
        fill_in('beer_name', with: '' )
        select(@style.name)
        select(@beer.brewery.name)
        expect{
          click_button('Create Beer')
        }.to change{Beer.count}.by(0)
        expect(page).to have_content "Name can't be blank"
      end

      it "will allow a beer to be updated" do
        visit beer_path(@beer)
        click_link "Update"
        expect(page).to have_content "Editing beer"
        fill_in('beer[name]', with: 'Better Factory Beer' )
        expect_any_instance_of(BeersController).to receive(:expire_beer_cache)
        click_button('Update Beer')
        expect(Beer.count).to eq(1)
        expect(page).to have_content "Beer was successfully updated."
        expect(page).to have_content "Better Factory Beer"
      end
    end

    describe "for a signed in admin user" do
      before :each do
        @admin_user = FactoryBot.create(:user, :admin, username: "Admin")
      end

      it "will allow a beer to be destroyed" do
        sign_in(username: "Admin", password: "Foobar1")
        expect(@admin_user.admin?).to eq(true)
        visit beer_path(@beer)
        expect(page).to have_content "Destroy"
        expect(page).to have_content "Update"
        expect_any_instance_of(BeersController).to receive(:expire_brewery_cache)
        expect_any_instance_of(BeersController).to receive(:expire_beer_cache)
        expect{
          click_link "Destroy"
        }.to change{Beer.count}.by(-1)
        expect(page).to have_content "Beer was successfully destroyed."
      end
    end
  end
end
