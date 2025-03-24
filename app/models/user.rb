class User < ApplicationRecord
  has_many :ratings   # käyttäjällä on monta ratingia
end
