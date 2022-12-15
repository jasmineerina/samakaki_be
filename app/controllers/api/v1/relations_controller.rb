class Api::V1::RelationsController < ApplicationController
  before_action :authorize, only: [:create, :update, :invite_user,:create_notif_invited_user]
  after_action :create_notif, only:[:invite_user]
  before_action :verif_email
  def create
    @find = Relation.find_by(relation_params)
    if @find.present?
      response_to_json(@find,:ok)
    else
      @relation_detail=Relation.relation_detail(params[:relation_name])
      @relation = Relation.new(relation_params.merge(code:@relation_detail[0][:code],user_id:@user.id,connected_user_id:params["connected_user_id"],status:"non_active"))
      @relation.save ? response_to_json(@relation.get_relation_from_invitation, :success) : response_error(@relation.errors, :unprocessable_entity)
    end
  end

  def update
    @relation = Relation.find(params[:id])
    @relation.update(relation_params) ? response_to_json({relation: @relation,message:"berhasil update relation"}, :success) : response_error(@relation.errors,:unprocessable_entity)
  end

  def create_notif_invited_user
    begin
      @token= JWT.decode(params[:token_invitation], SECRET_KEY)[0]
      @relation = Relation.find_by_id(@token["relation_id"])
      @notif = Notification.find_or_create_by(user_relation_id:@relation.user_relations[0].id,user_id:@user.id,status:0,descriptions:"Anda di invit ke dalam family tree oleh #{@relation.user_relations[0].user.name}, apakah anda mengenal #{@relation.user_relations[0].user.name}?")
      @notif ? response_to_json(@notif, :success) : response_error(@notif.errors, :unprocessable_entity)
    rescue JWT::DecodeError
      response_error("JWT TIDAK VALID",:unprocessable_entity)
    end
  end

  private

  def relation_params
    # @relation_params = Relation.relation(params[:relation_name])
    params.require(:relation).permit(:name,:relation_name)
  end

end


