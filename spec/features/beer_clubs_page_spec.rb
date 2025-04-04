require 'rails_helper'

describe "Beer clubs page" do
  let!(:user) { FactoryBot.create :user }
  let!(:beer_club) {FactoryBot.create :beer_club, name: "Maistajat"}
  it "should not have any before been created" do
    visit beer_clubs_path
    expect(page).to have_content 'Beer clubs'
  end

  describe "when beer clubs exists" do
    it "shows the name of the beer club" do
      visit beer_clubs_path
      expect(page).to have_content "Maistajat"
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
    end

  end
end