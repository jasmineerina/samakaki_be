class Api::V1::InvitationsController < ApplicationController
  before_action :decode ,only: [:create, :accepted]
  before_action :authorize, only: [:accepted]
  before_action :create_user_relation, only:[:accepted]
  def create
    @user = User.new(user_params)
    @user.password = params[:password]
    if params[:token].present?
      @user.save
      @relation=UserRelation.find_by(relation_id:@token["relation_id"])
      response_to_json({user: @user.new_attribute,relation:@relation.relation.relation_name,inviting_user:@relation.user.new_attribute},:success)
    else
      response_error("token invitations tidak valid",:unprocessable_entity)
    end
  end

  def accepted
    @relation = UserRelation.find_by(relation_id: @token["relation_id"])
    if @relation
      @relation.update(connected_user_id:@user.id)

    else
      response_error("data not found", :not_found)
    end
  end

  private

  def user_params
    params.permit(:name, :email, :phone, :password_digest)
  end

  def decode
    @token= JWT.decode(params[:token], 'secret')[0]
  end

  def create_user_relation
    @user_relation = @relation = UserRelation.find_by(relation_id: @token["relation_id"])
    @user_related = User.find_by_id(@user_relation.user_id)
    @relation = Relation.find_by(id: @user_relation.relation_id)
    @new_relation = Relation.create(name:@user_related.name,relation_name:"siblings",position:"right",number:"1",connected_user_id:@user_relation.user_id,user_id:@user.id,family_tree_id:"1")
    response_to_json({relation:@relation,new_relation:@new_relation.user_relations},:success)
  end
end
