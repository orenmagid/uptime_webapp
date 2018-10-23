class Api::V1::PossibilitiesController < ApplicationController

  def suggest_possibility
    exclude_poss_array = Activity.where(user_id: @current_user.id, exclude: true)

    exclude_poss_ids = exclude_poss_array.map {|x| x.possibility_id}.uniq

    limit_place = params[:location]
    timeLimit = params[:timeLimit].to_i

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


    @random_possibility = poss_array.sample
    render json: @random_possibility

  end

  def index
    @possibilities = Possibility.all
    render json: @possibilities

  end

end
