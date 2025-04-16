require 'rails_helper'

describe "Beerlist page" , :skip_in_ci do
  before :all do
    chromedriver_path = "/usr/bin/chromedriver"

    Capybara.register_driver :selenium do |app|
      Capybara::Selenium::Driver.new(app, browser: :chrome,
                                          service: Selenium::WebDriver::Service.chrome(path: chromedriver_path))
    end
    WebMock.allow_net_connect!
  end

  before :each do
    @brewery1 = FactoryBot.create(:brewery, name: "Koff")
    @brewery2 = FactoryBot.create(:brewery, name: "Schlenkerla")
    @brewery3 = FactoryBot.create(:brewery, name: "Ayinger")
    @style1 = FactoryBot.create(:style, name: "Lager")
    @style2 = FactoryBot.create(:style, name: "Rauchbier")
    @style3 = FactoryBot.create(:style, name: "Weisen")
    @beer1 = FactoryBot.create(:beer, name: "Nikolai", brewery: @brewery1, style:@style1)
    @beer2 = FactoryBot.create(:beer, name: "Fastenbier", brewery:@brewery2, style:@style2)
    @beer3 = FactoryBot.create(:beer, name: "Lechte Weisse", brewery:@brewery3, style:@style3)
  end

  it "shows one known beer", js:true do
    visit beerlist_path
    expect(page).to have_css('table tr', minimum: 2)
    rows = all('tr')
    expect(rows.size).to eq(4)
    expect(rows[0].text).to eq("Name Style Brewery")
    expect(rows[1].text).to eq("Fastenbier Rauchbier Schlenkerla")
    expect(rows[3].text).to eq("Nikolai Lager Koff")
    # save_and_open_page
    expect(page).to have_content "Nikolai"
  end

  it "shows the beers in alphabetical order", js: true do
    visit beerlist_path
    rows = all('tr')
    expect(rows[1].text).to eq("Fastenbier Rauchbier Schlenkerla")
    expect(rows[2].text).to eq("Lechte Weisse Weisen Ayinger")
    expect(rows[3].text).to eq("Nikolai Lager Koff")
  end

  it "shows beers ordered by style when 'Style' is clicked", js: true do
    visit beerlist_path
    expect(page).to have_css('table tr', minimum: 4) #wait until everything is loaded
    rows = all('tr')
    expect(rows.size).to eq(4)
    expect(rows[1].text).to eq("Fastenbier Rauchbier Schlenkerla")
    page.find_all(:xpath, "//*[normalize-space(text())='Style']").first.click
    rows = all('tr')
    expect(rows[1].text).to eq("Nikolai Lager Koff")
    expect(rows[3].text).to eq("Lechte Weisse Weisen Ayinger")
  end

  it "shows beers ordered by brewery when 'Brewery' is clicked", js: true do
    visit beerlist_path
    expect(page).to have_css('table tr', minimum: 4)
    rows = all('tr')
    expect(rows.size).to eq(4)
    page.find_all(:xpath, "//*[normalize-space(text())='Brewery']").first.click
    expect(page).to have_css('table tr', text: "Nikolai Lager Koff")
    rows = all('tr')
    expect(rows[1].text).to eq("Lechte Weisse Weisen Ayinger")
    expect(rows[3].text).to eq("Fastenbier Rauchbier Schlenkerla")
  end
end