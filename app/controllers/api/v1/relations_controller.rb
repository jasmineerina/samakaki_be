class Api::V1::RelationsController < ApplicationController
  before_action :authorize, only: [:create, :show, :update]

  def create
    @relation = Relation.new(relation_params)
      if @relation.save
          render json: {data:{relation: @relation},status: :success}
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


