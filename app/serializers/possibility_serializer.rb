class PossibilitySerializer < ActiveModel::Serializer
  has_many :activities
  # has_many :users, through: :activities

  attributes :id, :name, :description, :past_tense, :physical_intensity, :mental_intensity, :fun_index, :duration_in_minutes, :necessary_location, :others_required
end
