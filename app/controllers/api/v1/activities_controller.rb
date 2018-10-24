class Api::V1::ActivitiesController < ApplicationController

  def create
    possibility = params[:possibility]
    #-------activity accepted
    if params[:status] == "Accepted"
      if possibility[:name] == "Create a New Possibility for the Future"
        # Create new possibility
#---------------------------
      else
        @activity = Activity.new(status: "accepted", user_id: @current_user.id, possibility_id: possibility[:id])
        @activity.user = @current_user
        @activity.save
        render json: @activity
      end

    #-------reject activity
  elsif params[:status] == "Rejected"
      activity = Activity.create(status: "rejected", user_id: @current_user.id, possibility_id: possibility[:id])

      @possibility = Possibility.get_random_possibility(possibility[:limit_place], possibility[:timeLimit], @current_user)
      render json: @possibility
        #--rejects and exclude
    elsif params[:status] == "Rejected and Excluded"
      activity = Activity.create(status: "rejected", user_id: @current_user.id, possibility_id: possibility[:id], exclude: true)
      @possibility = Possibility.get_random_possibility(possibility[:limit_place], possibility[:timeLimit], @current_user)
      render json: @possibility
    end

  end

end
