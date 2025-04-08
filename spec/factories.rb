FactoryBot.define do
  factory :user do
    username { "Pekka" }
    password { "Foobar1" }
    password_confirmation { "Foobar1" }
  end

  factory :brewery do
    name { "Factory Brewery" }
    year { 1900 }
    active { true }
  end

  factory :style do
    name { "Factory Style" }
    description { "tasty" }
  end

  factory :beer do
    name { "Factory Beer" }
    association :style, factory: :style #olueen liittyvä tyyli luodaan style-tehtaalla
    association :brewery, factory: :brewery # olueen liittyvä panimo luodaan brewery-tehtaalla
  end

  factory :rating do
    score { 10 }
    beer
    user
  end

  factory :beer_club do
    name { "Factory Beer Club"}
    founded { 2000 }
  end

  factory :membership do
    user
    beer_club
  end
end
