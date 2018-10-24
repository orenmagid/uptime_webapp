class Possibility < ApplicationRecord
  has_many :activities
  has_many :users, through: :activities

  def self.get_random_possibility(limit_place, timeLimit, current_user)
    exclude_poss_array = Activity.where(user_id: current_user.id, exclude: true)

    exclude_poss_ids = exclude_poss_array.map {|x| x.possibility_id}.uniq

    if limit_place == "Work"
      location_time_exclude = Possibility.all.select do |possibility|
        possibility.duration_in_minutes.to_i <= timeLimit && ["Work", nil].include?(possibility.necessary_location)
      end
    elsif limit_place == "Home"
      location_time_exclude = Possibility.all.select do |possibility|
        possibility.duration_in_minutes.to_i <= timeLimit && ["Home", nil, "Somewhere Else"].include?(possibility.necessary_location)
      end
    elsif limit_place == "Somewhere Else"
      location_time_exclude = Possibility.all.select do |possibility|
        possibility.duration_in_minutes.to_i <= timeLimit && [nil, "Somewhere Else"].include?(possibility.necessary_location)
      end
    end

    poss_array = location_time_exclude.map{|poss_object| poss_object if !exclude_poss_ids.include?(poss_object.id)}.compact
    poss_array.sample
    end

end
