class Api::V1::InvitationsController < ApplicationController
  def create
    @user = User.new(user_params)
    @user.password = params[:password]
    if params[:token].present?
      @user.save
      @token= JWT.decode(params[:token], 'secret')[0]
      @relation=UserRelation.find_by(relation_id:@token["relation_id"])
      response_to_json({user: @user.new_attribute,relation:@relation.relation.relation_name,user_id:@relation.user.new_attribute},:success)
    else
      response_error("token invitations tidak valid",:unprocessable_entity)
    end
  end

  private

  def user_params
    params.permit(:name, :email, :phone, :password_digest)
  end
end
