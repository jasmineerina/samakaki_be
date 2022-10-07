class UsersController < ApplicationController
  before_action :authorize, only: [:show, :update, :destroy]
  def index
    @users = User.all.select('id', 'name','email','phone')
    render json: @users
  end

  def create
    @user = User.new(user_params)
    @user.password = user_params[:password_digest]
    token = encode_token({user_id: @user.id})
    if @user.save
      render json: {data:{user: @user.new_attribute, token: token}}
    else
      render json: {"message": @user.errors}, status: :bad_request
    end
  end

  def login
    @user = User.find_by_email(params[:email])
    if @user && @user.password == params[:password_digest]
      token = encode_token({id: @user.id, email: @user.email})
      render json: {data:{user: @user.new_attribute, token: token}}
    else
      render json: {error: 'Invalid email or password'}, status: :unprocessable_entity
    end
  end

  def show
    @user = User.find_by_id(@user.id)
    render json: @user.new_attribute
  rescue ActiveRecord::RecordNotFound => e
    render json: {
      error: e.to_s
      }, status: :not_found
  end

  def update
    if @user.update(user_params)
      render json: @user.new_attribute
    else
      render json: @user.errors, status: :bad_request
    end
  end


  private

  def user_params
    params.require(:user).permit(:name, :email, :phone, :password_digest)
  end
end
