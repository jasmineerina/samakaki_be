class Api::V1::UserRelationsController < ApplicationController
  before_action :authorize, only: [:index]
    def index
      @relations = UserRelation.where(user_id: @user.id).where.not(connected_user_id: nil)
      @relation_detail =[]
      @user=[]
      @relations.each_with_index do |relation, index|
        @user = User.find_by_id(relation.connected_user_id)
        @relation_detail.push(
          {
            user_relation:relation,relation:relation.relation,biodata:
            {
              biodata:@user.biodata_user
            }
          }
        )
      end
      render json: {data:@relation_detail,status: :success}
    end

    def show
      @relation = UserRelation.find_by_id(params[:id])
      @user = User.find_by_id(@relation.connected_user_id)
      render json: {data: {relation: @relation,user:@user,biodata:@user.biodata_user},status: :success}
    end
end


#  avatar: @user.biodata_user.avatar.url
