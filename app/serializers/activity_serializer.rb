class ActivitySerializer < ActiveModel::Serializer
  belongs_to :user
  belongs_to :possibility

  attributes :id, :status, :user_id, :possibility_id, :rating, :exclude, :time_expired
end
