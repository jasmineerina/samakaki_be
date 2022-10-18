class Api::V1::RelationsController < ApplicationController
  before_action :authorize, only: [:create, :update]

  def create
    @relation = Relation.new(relation_params.merge(user_id:@user.id,family_tree_id: params["family_tree_id"],connected_user_id:params["connected_user_id"]))
      if @relation.save
        render json: @relation.get_relation_from_invitation
      else
        render json: {"message": @relation.errors}, status: :bad_request
      end
  end

  def update
    @relation = Relation.find(params[:id])
    if @relation.update(relation_params)
      render json: {data: {relation: @relation}, message: "Your relation was succesfully updated"}
    else
      render json: @relation.errors
    end
  end

  private

  def relation_params
    params.require(:relation).permit(:name,:relation_name,:position,:number)
  end
end


