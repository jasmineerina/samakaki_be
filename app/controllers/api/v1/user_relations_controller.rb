class Api::V1::UserRelationsController < ApplicationController
  before_action :authorize, only: [:index,:show]
  before_action do
    ActiveStorage::Current.url_options = { protocol: request.protocol, host: request.host, port: request.port }
  end
    def index
    @relation_detail = UserRelation.get_relation(@user)
    @relation_detail.map do |relation_detail|
    end
    return response_error("Tidak ada relation", :not_found) unless @relation_detail.presence
      response_to_json(@relation_detail,:success)
    end

    def show
      @relation = UserRelation.find_by_id(params[:id])
      if @relation
        @user = User.find_by_id(@relation.connected_user_id)
        response_to_json({relation: @relation.relation,user:@user,biodata:@user.biodata_user,avatar:@user.biodata_user.avatar.url},status: :success)
      else
        response_error("relation tidak ditemukan",:not_found)
      end
    end
end


      # @relation_detail =[]
      # @relations = UserRelation.where(user_id: @user.id)
      # @user=[]
      # @relations.map do |relation|
      #   if relation.connected_user_id == nil
      #     @relation_detail.push(relation_detail:{user_relation:relation,relation:relation.relation})
      #   else
      #     @user_id = User.find_by_id(relation.connected_user_id)
      #     @relation_detail.push(relation_detail:{user_relation:relation,relation:relation.relation, user:@user_id, avatar:@user_id.biodata_user.avatar.url})
      #   end
      #   @relations_connected_user = UserRelation.where(user_id: relation.connected_user_id)
      #   @relations_connected_user.map do |relation_connected_user|
      #     if relation_connected_user.connected_user_id == nil
      #       @relation_detail.push(relation_detail:{user_relation:relation_connected_user,relation:relation_connected_user.relation})
      #     else
      #       @user = User.find_by_id(relation_connected_user.connected_user_id)
      #       @relation_detail.push(relation_detail:{user_relation:relation_connected_user,relation:relation_connected_user.relation,user:@user,avatar:@user.biodata_user.avatar.url})
      #     end
      #   end
      # end
