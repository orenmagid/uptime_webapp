class Api::V1::PossibilitiesController < ApplicationController

  def suggest_possibility
    limit_place = params[:location]
    timeLimit = params[:timeLimit].to_i

    @random_possibility = Possibility.get_random_possibility(limit_place, timeLimit, @current_user)
    render json: @random_possibility
  end

  def index
    @possibilities = Possibility.all
    render json: @possibilities
  end

  def get_possibility_rating
    all_associated_activities_array = Activity.where(possibility_id: params[:id])

    all_associated_rated_activities_array = all_associated_activities_array.select {|activity| activity.rating != nil}

    if all_associated_rated_activities_array.length != 0
      @avg_rating = (all_associated_rated_activities_array.reduce(0) {|sum, n| sum + n.rating } / all_associated_rated_activities_array.length).to_f
    else
      @avg_rating = nil
    end
    render json: @avg_rating
  end

end
