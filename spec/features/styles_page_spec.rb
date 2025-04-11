require 'rails_helper'

include Helpers

describe "Styles page" do
  
  describe "with at least one style" do
    before :each do
      @style = FactoryBot.create :style
    end

    it "displays the number of styles" do
      visit styles_path
      expect(page).to have_content "Number of beer styles: 1"
      expect(page).to have_content "Factory Style"
    end

    it "has links to style pages" do
      visit styles_path
      expect(page).to have_link "Factory Style"
      click_link "Factory Style"
      expect(page).to have_content "tasty"
    end

    describe "a signed in user" do
      before :each do 
        FactoryBot.create :user
      end

      it "can create a new style, if name and description are given" do
        sign_in(username: "Pekka", password: "Foobar1")
        visit new_style_path
        fill_in('style_name', with: 'Factory IPA')
        fill_in('style_description', with: 'Factory IPA style')
        expect{
          click_button('Create Style')
        }.to change{Style.count}.by(1)
        expect(page).to have_content "Style was successfully created"
        expect(page).to have_content "Name: Factory IPA"
        expect(page).to have_content "Factory IPA style"
      end

      it "will not create a new style with no name" do
        sign_in(username: "Pekka", password: "Foobar1")
        visit new_style_path
        fill_in('style_name', with: '')
        fill_in('style_description', with: 'Factory IPA style')
        expect{
          click_button('Create Style')
        }.to change{Style.count}.by(0)
        expect(page).to_not have_content "Style was successfully created"
        expect(page).to have_content "Name can't be blank"
      end

      it "will not create a new style with no description" do
        sign_in(username: "Pekka", password: "Foobar1")
        visit new_style_path
        fill_in('style_name', with: 'Factory IPA')
        fill_in('style_description', with: '')
        expect{
          click_button('Create Style')
        }.to change{Style.count}.by(0)
        expect(page).to_not have_content "Style was successfully created"
        expect(page).to have_content "Description can't be blank"
      end

      it "will let user update the created style" do
        sign_in(username: "Pekka", password: "Foobar1")
        visit new_style_path
        fill_in('style_name', with: 'Factory IPA')
        fill_in('style_description', with: 'Factory IPA style')
        expect{
          click_button('Create Style')
        }.to change{Style.count}.by(1)
        expect(page).to have_content "Style was successfully created"
        expect(page).to have_content "Name: Factory IPA"
        click_link("Update")
        fill_in('style_name', with: 'New Factory IPA')
        expect{
          click_button('Update Style')
        }.to change{Style.count}.by(0)
        expect(page).to have_content "Style was succesfully updated"
        expect(page).to have_content "New Factory IPA"
      end

      it "will let user delete a style" do
        sign_in(username: "Pekka", password: "Foobar1")
        FactoryBot.create(:beer, style: @style)
        expect(Beer.count).to eq(1)
        visit style_path(@style)
        expect{
          click_link('Destroy')
        }.to change{Style.count}.by(-1)
        expect(Beer.count).to eq(0) 
        expect(page).to have_content "Style was successfully destroyed"
      end
    end

  end


end