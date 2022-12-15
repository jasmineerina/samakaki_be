class Api::V1::InvitationsController < ApplicationController
  before_action :decode ,only: [:create, :accepted]
  before_action :authorize, only: [:accepted]
  after_action :create_user_relation, only:[:accepted]
  after_action :create_notif, only:[:create]
  before_action :verif_email , only: [:accepted]

  def create
    @user = User.new(user_params)
    @user.password = params[:password]
    if params[:token].present?
      @user.save
      UserMailer.registration_confirmation(@user).deliver
      @relation=UserRelation.find_by(relation_id:@token["relation_id"])
      @token_login = encode_token({user_id: @user.id, email: @user.email})
      response_to_json({user: @user.new_attribute,relation:@relation.relation.relation_name,inviting_user:@relation.user.new_attribute,token_login:@token_login, token_invitation:params[:token]},:success)
    else
      response_error("token invitations tidak valid",:unprocessable_entity)
    end
  end

  def accepted
    @relation = UserRelation.find_by(relation_id: @token["relation_id"])
    @notif = Notification.find_by(user_id:@user.id, user_relation_id:@relation.id)
    @notif.update(status:"read")
    if @relation
      @relation.update(connected_user_id:@user.id,status:1)
      response_to_json({relation:@relation},:success)
    else
      response_error("data not found", :not_found)
    end
  end

  private

  def user_params
    params.permit(:name, :email, :phone, :password_digest)

  end

  def decode
    @token= JWT.decode(params[:token], SECRET_KEY)[0]
  end

  def create_user_relation
    @user_relation = UserRelation.find_by(relation_id: @token["relation_id"])
    @user_related = User.find_by_id(@user_relation.user_id)
    @relation = Relation.find_by(id: @user_relation.relation_id)
    @relation_detail = Relation.relation_detail(params[:relation_name])
    @handling = UserRelation.find_by(connected_user_id:@user_relation.user_id,user_id:@user.id)
    if @handling==nil
      @new_relation = Relation.create(name:@user_related.name,relation_name:params["relation_name"],code:@relation_detail[0][:code],connected_user_id:@user_relation.user_id,user_id:@user.id, status:1)
      @notif = Notification.find_or_create_by(user_relation_id:@new_relation.user_relation_ids[0],user_id:@user_relation.user_id,status:0,descriptions:"Undangan anda sudah diterima oleh #{@user.name}")
    end
  end

  def create_notif
    @notif = Notification.find_or_create_by(user_relation_id:@relation.id,user_id:@user.id,status:0,descriptions:"Anda di undang ke dalam family tree oleh #{@relation.user.name}, apakah anda mengenal #{@relation.user.name}?")
  end

end
