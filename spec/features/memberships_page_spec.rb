require 'rails_helper'

include Helpers

describe "Memberships page" do
  let!(:beer_club) { FactoryBot.create :beer_club }
  let!(:beer_club2) { FactoryBot.create :beer_club, name: "New Club" }
  let!(:user) { FactoryBot.create :user }
  let!(:user2) { FactoryBot.create :user, username: "Bob" }
  let!(:membership) { FactoryBot.create :membership, user: user2, beer_club: beer_club }

  it "shows all the memberships" do
    visit memberships_path
    expect(page).to have_content "#{user2.username}: #{beer_club.name}"
    expect(Membership.count).to eq(1)
  end

  describe "for a signed in user" do
    before :each do
      sign_in(username: "Pekka", password: "Foobar1")
    end

    it "shows a link for creating a membership" do
      visit memberships_path
      expect(page).to have_content "New membership"
    end

    it "allows the user to join a beer club" do
      visit new_membership_path
      select('Factory Beer Club', from:'membership[beer_club_id]')
      expect{
        click_button "Create Membership"
      }.to change{Membership.count}.from(1).to(2)
      expect(page).to have_content "Welcome to the club, #{user.username}."
      expect(page).to have_content "Factory Beer Club"
    end

    describe "with a membership" do
      before :each do
        sign_in(username: "Pekka", password: "Foobar1")
        @membership2 = FactoryBot.create(:membership, user: user, beer_club: beer_club)
      end
    
      it "allows the user to update the membership" do
        visit membership_path(@membership2)
        expect(Membership.count).to eq(2)
        expect(page).to have_content "Update"
        click_link "Update"
        select('New Club', from:'membership[beer_club_id]')
        click_button "Update Membership"
        expect(Membership.count).to eq(2)
        expect(page).to have_content "Membership was successfully updated."
        expect(page).to have_content "Beer club: #{beer_club2.name}"
      end

      it "allows the user to end the membership" do
        visit membership_path(@membership2)
        expect(page).to have_link "Destroy"
        expect(page).to have_content "User: #{user.username}"
        expect{
          click_link "Destroy"
        }.to change{Membership.count}.from(2).to(1)
        expect(page).to have_content "Membership in #{beer_club.name} ended."
      end

      it "will not allow duplicate memberships" do
        visit new_membership_path
        expect(Membership.count).to eq(2)
        select('Factory Beer Club', from: 'membership[beer_club_id]')
        click_button "Create Membership"
        expect(Membership.count).to eq(2)
        expect(page).to have_content "You are already a member."
      end
    end
  end
end
