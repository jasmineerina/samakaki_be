class Api::V1::UserRelationsController < ApplicationController
  before_action :authorize, only: [:index,:show]
  before_action do
    ActiveStorage::Current.url_options = { protocol: request.protocol, host: request.host, port: request.port }
  end
    def index
      @relation_detail =[]
      @relations = UserRelation.where(user_id: @user.id)
      @user=[]
      @relations.each do |relation|
        @relations_connected_user = UserRelation.where(connected_user_id:relation.connected_user_id)
        @relations_connected_user.each do |relation_connected_user|
        if relation.connected_user_id == nil
          @relation_detail.push(relation_detail:{user_relation:relation_connected_user.relation,relation:relation_connected_user.relation})
        else
          @user = User.find_by_id(relation_connected_user.connected_user_id)
          @relation_detail.push(relation_detail:{user_relation:relation_connected_user,relation:relation_connected_user.relation,user: @user,biodata:@user.biodata_user,avatar:@user.biodata_user.avatar.url})
        end
        end
      end
      @relations.each_with_index do |relation, index|
        if relation.connected_user_id == nil
          @relation_detail.push(relation_detail:{user_relation:relation.relation,relation:relation.relation})
        else
          @user = User.find_by_id(relation.connected_user_id)
          @relation_detail.push(relation_detail:{user_relation:relation,relation:relation.relation,user: @user,biodata:@user.biodata_user,avatar:@user.biodata_user.avatar.url})
        end
      end
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
# .where.not(connected_user_id: nil)

