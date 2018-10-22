class Api::V1::UsersController < ApplicationController
  skip_before_action :authenticate, only: [:create]

  before_action :find_user, only: [:show, :update]
  skip_before_action :authenticate, only: [:create]

 def index
   @users = User.all
   render json: @users
 end

  def show
    render json: @current_user
  end


  def show_user
    render json: @current_user
  end

  def create
  @user = User.new(user_params)
  if @user.save
    token = encode({user_id: @user.id})
    render json: { token: token, status: :accepted, success: true, user: @user }
    # render json: @user, status: :accepted
  else
    render json: { errors: @user.errors.full_messages }, status: :unprocessible_entity
  end
end

 def update
   @current_user.update(user_params)
   if @current_user.save
     render json: @current_user, status: :accepted
   else
     render json: { errors: @current_user.errors.full_messages }, status: :unprocessible_entity
   end
 end

 private

 def user_params
   params.require(:user).permit(:id, :first_name, :last_name, :username, :email, :password, :phone_number, :location, :age, :height_in_inches, :highest_experience, :latitude, :longitude)
 end

 def find_user
   @current_user = User.find(params[:id])
 end
end
