class User < ApplicationRecord
  has_many :activities
  has_many :possibilities, through: :activities

  has_secure_password

end
