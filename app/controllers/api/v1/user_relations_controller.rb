class Api::V1::UserRelationsController < ApplicationController
  before_action :authorize, only: [:index,:show]
  before_action do
    ActiveStorage::Current.url_options = { protocol: request.protocol, host: request.host, port: request.port }
  end
    def index
      @relations = UserRelation.where(user_id: @user.id)
      @relation_detail =[]
      @user=[]
      @relations.each_with_index do |relation, index|
        if relation.connected_user_id==nil
          @relation_detail.push(relation:{relation_user:relation.relation})
        else
          @user = User.find_by_id(relation.connected_user_id)
          @relation_detail.push(relation:{relation_user:relation.relation,user: @user,biodata:@user.biodata_user,avatar:@user.biodata_user.avatar.url})
        end
      end
      response_to_json({relations: @relation_detail},:success)
    end

    def show
      @relation = UserRelation.find_by_id(params[:id])
      @user = User.find_by_id(@relation.connected_user_id)
      response_to_json({relation: @relation.relation,user:@user,biodata:@user.biodata_user,avatar:@user.biodata_user.avatar.url},status: :success)
    end
end
# .where.not(connected_user_id: nil)

