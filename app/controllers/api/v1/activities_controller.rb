class Api::V1::ActivitiesController < ApplicationController
  before_action :find_activity, only: [:update]

  def create
    possibility = params[:possibility]
    limit_place = params[:location]
    timeLimit = params[:timeLimit]

    #-------activity accepted
    if params[:status] == "Accepted"
      if possibility[:name] == "Create a New Possibility for the Future"
        # Create new possibility
#---------------------------
      else
        @activity = Activity.new(status: "Accepted", user_id: @current_user.id, possibility_id: possibility[:id])
        @activity.user = @current_user
        @activity.save
        render json: @activity
      end

    #-------reject activity
  elsif params[:status] == "Rejected"
      activity = Activity.create(status: "Rejected", user_id: @current_user.id, possibility_id: possibility[:id])

      @possibility = Possibility.get_random_possibility(limit_place, timeLimit, @current_user)
      render json: @possibility
        #--rejects and exclude
    elsif params[:status] == "Rejected and Excluded"
      activity = Activity.create(status: "rejected", user_id: @current_user.id, possibility_id: possibility[:id], exclude: true)
      @possibility = Possibility.get_random_possibility(limit_place, timeLimit, @current_user)
      render json: @possibility
    end

  end

  def update
    @activity.update(activity_params)
    render json: @activity


  end

  private

  def find_activity
    @activity = Activity.find(params[:id])

  end

  def activity_params
    params.require(:activity).permit(:id, :status, :user_id, :possibility_id, :rating, :exclude)
  end
  

end
