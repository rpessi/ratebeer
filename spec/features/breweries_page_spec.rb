require 'rails_helper'

include Helpers

describe "Breweries page" do
  it "should not have any before been created" do
    visit breweries_path
    expect(page).to have_content 'Breweries'
    expect(page).to have_content 'Number of active breweries: 0'
  end

  describe "when breweries exists" do
    before :each do
      @breweries = ["Koff", "Karjala", "Schlenkerla"]
      year = 1896
      @breweries.each do |brewery_name|
        FactoryBot.create(:brewery, name: brewery_name, year: year += 1)
      end

      visit breweries_path
    end

    # unresolved problems with testing turboframes
    it "lists the existing breweries and their total number", :skip_in_ci do
      expect(page).to have_content "Number of active breweries: #{@breweries.count}"
      turbo_frame = page.find("turbo-frame#active_breweries_frame")
      within("turbo-frame#active_breweries_frame") do
        Capybara.using_wait_time(5) do
          @breweries.each do |brewery_name|
            page.find("td", text: brewery_name)
            expect(turbo_frame).to have_content brewery_name
          end
        end
      end
    end

    # unresolved problems with testing turboframes
    it "allows user to navigate to page of a Brewery", :skip_in_ci do
      within("turbo-frame#active_breweries_frame") do
        Capybara.using_wait_time(5) do
          page.find("td", text: "Koff") 
          click_link "Koff"
        end
      end

      expect(page).to have_content "Koff"
      expect(page).to have_content "Established in 1897"
    end

    describe "it allows a signed in user" do
      before :each do
        FactoryBot.create :user
        @brewery = FactoryBot.create :brewery
      end

      it "to create a new brewery with valid credentials" do
        sign_in(username: "Pekka", password: "Foobar1")
        visit new_brewery_path
        fill_in('brewery_name', with: 'Old Factory Brewery')
        fill_in('brewery_year', with: '1968')
        expect{
          click_button('Create Brewery')
        }.to change{Brewery.count}.by(1)
        expect(page).to have_content "Old Factory Brewery"
        expect(page).to have_content "Established in 1968"
        expect(page).to have_content "Brewery was successfully created."
      end

      it "to update a brewery" do
        sign_in(username: "Pekka", password: "Foobar1")
        visit brewery_path(@brewery)
        click_link "Update"
        fill_in('brewery_name', with: 'Updated Brewery')
        expect{
          click_button('Update Brewery')
        }.to change{Brewery.count}.by(0)
        expect(page).to have_content "Brewery was successfully updated."
        expect(page).to have_content "Updated Brewery"
      end

      it "to change activity of a brewery" do
        sign_in(username: "Pekka", password: "Foobar1")
        visit brewery_path(@brewery)
        expect(page).to have_link "Change activity"
        click_link('Change activity')
        @brewery.reload
        expect(@brewery.active).to eq(false)
        expect(page).to have_content "Brewery activity status changed to retired"
        expect(page).to have_content "Retired"
        click_link('Change activity')
        @brewery.reload
        expect(@brewery.active).to eq(true)
        expect(page).to have_content "Brewery activity status changed to active"
        expect(page).to_not have_content "Retired"
      end

      describe "to make no changes with invalid credentials" do
        it "will not create new brewery with no name" do
          sign_in(username: "Pekka", password: "Foobar1")
          visit new_brewery_path
          fill_in('brewery_name', with: '')
          fill_in('brewery_year', with: '1968')

          expect{
            click_button('Create Brewery')
          }.to change{Brewery.count}.by(0)
          expect(page).to have_content "Name can't be blank"
        end

        it "will not create new brewery with no year" do
          sign_in(username: "Pekka", password: "Foobar1")
          visit new_brewery_path
          fill_in('brewery_name', with: 'Old Factory Brewery')
          fill_in('brewery_year', with: '')

          expect{
            click_button('Create Brewery')
          }.to change{Brewery.count}.by(0)
          expect(page).to have_content "Year can't be blank"
        end

        it "will not update brewery with no name" do
          sign_in(username: "Pekka", password: "Foobar1")
          visit brewery_path(@brewery)
          click_link('Update')
          fill_in('brewery_name', with: '')

          expect{
            click_button('Update')
          }.to change{Brewery.count}.by(0)
          expect(page).to have_content "Name can't be blank"
        end

        it "will not update brewery with no year" do
          sign_in(username: "Pekka", password: "Foobar1")
          visit brewery_path(@brewery)
          click_link('Update')
          fill_in('brewery_year', with: '')

          expect{
            click_button('Update Brewery')
          }.to change{Brewery.count}.by(0)
          expect(page).to have_content "Year can't be blank"
        end
      end
    end

    describe "for a signed in admin user" do
      before :each do
        @admin_user = FactoryBot.create(:user, :admin, username: "Admin")
        @brewery = FactoryBot.create :brewery
      end

      it "will allow a beer_club to be destroyed" do
        sign_in(username: "Admin", password: "Foobar1")
        expect(@admin_user.admin?).to eq(true)
        visit brewery_path(@brewery)
        expect(page).to have_content "Factory Brewery"
        expect(page).to have_content "Destroy"
        expect(page).to have_content "Update"
        expect{
          click_link "Destroy"
        }.to change{Brewery.count}.by(-1)
        expect(page).to have_content "Brewery was successfully destroyed."
      end
    end
  end
end
