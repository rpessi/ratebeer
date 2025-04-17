require 'rails_helper'

include Helpers

describe "Beer clubs page" do
  let!(:user) { FactoryBot.create :user }

  it "should not have any before been created" do
    visit beer_clubs_path
    expect(page).to have_content 'Beer clubs'
    expect(page).to_not have_content 'Maistajat'
  end

  describe "when beer clubs exists" do
    let!(:beer_club) { FactoryBot.create :beer_club, name: "Maistajat" }
    let!(:beer_club2) { FactoryBot.create :beer_club,
                                           name: "Siemailijat",
                                           founded: 1990,
                                           city: "Helsinki" }

    it "shows the names of the beer clubs" do
      visit beer_clubs_path
      expect(page).to have_content "Maistajat"
      expect(page).to have_content "Siemailijat"
    end

    it "allows the clubs to be sorted by 'founded'" do
      visit beer_clubs_path
      expect(page).to have_css('table tr', minimum: 3)
      rows = all('tr')
      expect(rows[1].text).to eq("Maistajat 2000 Turku")
      click_link('Founded')
      expect(page).to have_css('table tr', minimum: 3)
      rows = all('tr')
      expect(rows[1].text).to eq("Siemailijat 1990 Helsinki")
    end

    it "allows the clubs to be sorted by 'city'" do
      visit beer_clubs_path
      expect(page).to have_css('table tr', minimum: 3)
      rows = all('tr')
      expect(rows[1].text).to eq("Maistajat 2000 Turku")
      click_on('City')
      expect(page).to have_css('table tr', minimum: 3)
      rows = all('tr')
      expect(rows[1].text).to eq("Siemailijat 1990 Helsinki")
    end

    it "allows the clubs to be sorted by 'name'" do
      visit beer_clubs_path
      click_on('City')
      expect(page).to have_css('table tr', minimum: 3)
      rows = all('tr')
      #if rows.size == 3
      expect(rows[1].text).to eq("Siemailijat 1990 Helsinki")
      click_on('Name')
      expect(page).to have_css('table tr', minimum: 3)
      rows = all('tr')
      expect(rows[1].text).to eq("Maistajat 2000 Turku")
    end

    describe "for a signed in user" do
      before :each do
        sign_in(username: "Pekka", password: "Foobar1")
      end

      it "who is a member, it lets the user to end the membership" do
        Membership.create(beer_club_id: beer_club.id, user_id: user.id)
        expect(user.memberships.count).to eq(1)

        visit beer_club_path(beer_club)
        expect(page).to have_content "Members"
        expect(page).to have_button "End the membership"

        click_button "End the membership"
        expect(page).to have_content "Membership in Maistajat ended."
        expect(user.memberships.count).to eq(0)
      end

      it "who is not a member, it lets the user to create a membership" do
        expect(user.memberships.count).to eq(0)
        visit beer_club_path(beer_club)
        expect(page).to_not have_content "Members"
        expect(page).to have_button "Join the beer club"

        click_button "Join the beer club"
        expect(page).to have_content "Welcome to the club, Pekka."
        expect(user.memberships.count).to eq(1)
      end

      it "it allows the user to create a new beer club with valid credentials" do
        visit new_beer_club_path
        fill_in('beer_club_name', with: 'New Factory Beerclub')
        fill_in('beer_club_founded', with: 1968)
        fill_in('beer_club_city', with: 'Helsinki')

        expect{
          click_button('Create Beer club')
        }.to change{BeerClub.count}.by(1)
        expect(page).to have_content "New Factory Beerclub"
        expect(page).to have_content "Founded: 1968"
        expect(page).to have_content "Beer club was successfully created."
      end

      it "allows the user to edit a beer club" do
        visit beer_club_path(beer_club)
        expect(page).to have_content "Maistajat"
        click_link('Update')
        fill_in('beer_club_name', with: 'Wanhat Maistajat')

        expect{
          click_button('Update')
        }.to change{BeerClub.count}.by(0)
        expect(page).to have_content "Wanhat Maistajat"
        expect(page).to have_content "Founded: 2000"
        expect(page).to have_content "Beer club was successfully updated."
      end
    end

    describe "for a signed in admin user" do
      before :each do
        @admin_user = FactoryBot.create(:user, :admin, username: "Admin")
      end

      it "will allow a beer_club to be destroyed" do
        sign_in(username: "Admin", password: "Foobar1")
        expect(@admin_user.admin?).to eq(true)
        visit beer_club_path(beer_club)
        expect(page).to have_content "Destroy"
        expect(page).to have_content "Update"
        expect{
          click_link "Destroy"
        }.to change{BeerClub.count}.by(-1)
        expect(page).to have_content "Beer club was successfully destroyed."
      end
    end
  end
end