require 'rails_helper'

describe "Brewerylist page" , :skip_in_ci do
  before :all do
    chromedriver_path = "/usr/bin/chromedriver"

    Capybara.register_driver :selenium do |app|
      Capybara::Selenium::Driver.new(app, browser: :chrome,
                                          service: Selenium::WebDriver::Service.chrome(path: chromedriver_path))
    end
    WebMock.allow_net_connect!
  end

  before :each do
    @brewery1 = FactoryBot.create(:brewery, name: "Koff", year: 1897)
    @brewery2 = FactoryBot.create(:brewery, name: "Schlenkerla", year: 1886)
    @brewery3 = FactoryBot.create(:brewery, name: "Ayinger", year: 1930)
    @style1 = FactoryBot.create(:style, name: "Lager")
    @style2 = FactoryBot.create(:style, name: "Rauchbier")
    @style3 = FactoryBot.create(:style, name: "Weisen")
    @beer1 = FactoryBot.create(:beer, name: "Nikolai", brewery: @brewery1, style:@style1)
    @beer2 = FactoryBot.create(:beer, name: "Fastenbier", brewery:@brewery2, style:@style2)
    @beer3 = FactoryBot.create(:beer, name: "Lechte Weisse", brewery:@brewery3, style:@style3)
    @beer4 = FactoryBot.create(:beer, brewery: @brewery1)
    @beer5 = FactoryBot.create(:beer, name: "Another beer", brewery: @brewery1)
    @beer6 = FactoryBot.create(:beer, name: "New beer", brewery: @brewery2)
  end

  it "shows one known brewery", js:true do
    visit brewerylist_path
    expect(page).to have_css('table tr', minimum: 2)
    rows = all('tr')
    expect(rows.size).to eq(4)
    expect(rows[0].text).to eq("Name Year Beercount Active")
    expect(rows[1].text).to eq("Ayinger 1930 1 true")
    # save_and_open_page
    expect(page).to have_content "Ayinger"
  end

  it "shows the breweries in alphabetical order", js: true do
    visit brewerylist_path
    rows = all('tr')
    expect(rows[1].text).to eq("Ayinger 1930 1 true")
    expect(rows[2].text).to eq("Koff 1897 3 true")
    expect(rows[3].text).to eq("Schlenkerla 1886 2 true")
  end

  it "shows breweries ordered by year (oldest first) when 'Year' is clicked", js: true do
    visit brewerylist_path
    expect(page).to have_css('table tr', minimum: 4) #wait until everything is loaded
    rows = all('tr')
    expect(rows.size).to eq(4)
    expect(rows[1].text).to eq("Ayinger 1930 1 true")
    page.find_all(:xpath, "//*[normalize-space(text())='Year']").first.click
    rows = all('tr')
    expect(rows[1].text).to eq("Schlenkerla 1886 2 true")
    expect(rows[3].text).to eq("Ayinger 1930 1 true")
  end

  it "shows breweries ordered by beer count when 'Number of beers' is clicked", js: true do
    visit brewerylist_path
    expect(page).to have_css('table tr', minimum: 4) #wait until everything is loaded
    rows = all('tr')
    expect(rows.size).to eq(4)
    expect(rows[1].text).to eq("Ayinger 1930 1 true")
    page.find_all(:xpath, "//*[normalize-space(text())='Beercount']").first.click
    rows = all('tr')
    expect(rows[1].text).to eq("Koff 1897 3 true")
    expect(rows[3].text).to eq("Ayinger 1930 1 true")
  end
end