class User < ApplicationRecord
  has_many: activities
  has_many: possibilities, through: :activities
  
end
