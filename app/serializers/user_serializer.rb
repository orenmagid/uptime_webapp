class UserSerializer < ActiveModel::Serializer
  has_many :activities
  has_many :possibilities, through: :activities

  attributes :id, :first_name, :last_name, :nick_name, :username, :email
end
