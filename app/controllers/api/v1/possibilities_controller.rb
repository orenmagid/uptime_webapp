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

end
