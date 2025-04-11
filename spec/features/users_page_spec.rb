require 'rails_helper'

include Helpers

describe "User" do
  before :each do
    @user = FactoryBot.create :user
    @user2 = FactoryBot.create(:user, username: "Bob")
  end

  describe "who has signed up" do
    it "can signin with right credentials" do
      sign_in(username: "Pekka", password: "Foobar1")

      expect(page).to have_content 'Welcome back!'
      expect(page).to have_content 'Pekka'
    end

    it "is redirected back to signin form if wrong credentials given" do
      sign_in(username: "Pekka", password: "wrong")

      expect(current_path).to eq(signin_path)
      expect(page).to have_content 'Username and/or password mismatch'
    end

    it "can update the password" do
      sign_in(username: "Pekka", password: "Foobar1")
      visit user_path(@user)
      click_link('Update')
      fill_in('user_password', with: "Foobar2")
      fill_in('user_password_confirmation', with: "Foobar2")
      expect{
        click_button('Update User')
      }.to change{User.count}.by(0)
      expect(page).to have_content "User was successfully updated."
    end

    it "can delete the user" do
      sign_in(username: "Pekka", password: "Foobar1")
      visit user_path(@user)
      expect{
        click_link('Destroy')
      }.to change{User.count}.by(-1)
      expect(page).to have_content "User was successfully destroyed."
    end

    it "can sign out" do
      sign_in(username: "Pekka", password: "Foobar1")
      click_link('Sign out')
      expect(page).to have_content "Sign up"
      expect(page).to have_content "Sign in"
    end

    it "cannot delete another user" do
      sign_in(username: "Pekka", password: "Foobar1")
      visit user_path(@user2)
      expect(page).to_not have_content "Destroy this user"
    end

    describe "has a user page that" do
      it "shows no favorite beer style if user has no ratings" do
        visit user_path(@user)

        expect(page).to have_content "User has no ratings"
        expect(page).not_to have_content "Favorite beer style"
      end

      it "shows no favorite brewery if user has no ratings" do
        visit user_path(@user)

        expect(page).to have_content "User has no ratings"
        expect(page).not_to have_content "Favorite brewery"
      end

      it "shows user's favorite beer style if user has ratings" do
        create_beer_with_rating({ user: @user }, 25)
        visit user_path(@user)

        expect(page).to have_content "Favorite beer style"
        expect(page).to have_content @user.favorite_style
      end

      it "shows user's favorite brewery if user has ratings" do
        create_beer_with_rating({ user: @user }, 25)
        visit user_path(@user)

        expect(page).to have_content "Favorite brewery"
        expect(page).to have_content @user.favorite_brewery
      end
    end
  end

  describe "who it not signed up" do
    it "when signed up with good credentials, is added to the system" do
      visit signup_path
      fill_in('user_username', with: 'Brian')
      fill_in('user_password', with: 'Secret55')
      fill_in('user_password_confirmation', with: 'Secret55')
    
      expect{
        click_button('Create User')
      }.to change{User.count}.by(1)
      expect(page).to have_content "User was successfully created."
    end

    it "when signed up with bad credentials, is not added to the system" do
      visit signup_path
      fill_in('user_username', with: 'Brian')
      fill_in('user_password', with: 'Secret55')
      fill_in('user_password_confirmation', with: 'Secret5')
    
      expect{
        click_button('Create User')
      }.to change{User.count}.by(0)
      expect(page).to have_content "Password confirmation doesn't match Password"

      visit signup_path
      fill_in('user_username', with: 'Bo')
      fill_in('user_password', with: 'Secret55')
      fill_in('user_password_confirmation', with: 'Secret55')
    
      expect{
        click_button('Create User')
      }.to change{User.count}.by(0)
      expect(page).to have_content "Username is too short"
    end
  end

end
