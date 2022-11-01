class Api::V1::UsersController < ApplicationController
  before_action :authorize, only: [:show, :update, :destroy]
  def index
    @users = User.all.select('id', 'name','email','phone')
    render json: @users
  end

  def create
    if params[:password] != ""
    @user = User.new(user_params)
    @user.password = params[:password]
    @token = encode_token({user_id: @user.id, email: @user.email})
    @user.save ? response_to_json({user:@user,token:@token}, :ok) : response_error(@user.errors, :unprocessable_entity)
    else
      response_error("password tidak boleh kosong", :unprocessable_entity)
    end
  end

  def login
    @user = User.find_by(email: params[:email])
    if @user && @user.password == params[:password]
      @token = encode_token({id: @user.id, email: @user.email})
      response_to_json({user:@user.new_attribute,token:@token},:success)
    else
      response_error("email atau password salah",:unprocessable_entity)
    end

  end

  def show
    response_to_json(@user.new_attribute,:success)
  end

  def update
    @user.update(user_params) ? response_to_json(@user.new_attribute, :ok) : response_error(@user.errors, :unprocessable_entity)
  end

  def destroy
    @user.destroy ? response_to_json(@user.new_attribute, :success) : response_error(@user.errors, :error)
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :phone, :password_digest)
  end
end
