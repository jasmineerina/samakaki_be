class Api::V1::FamilyTreesController < ApplicationController
  before_action :authorize, only: [:create, :show, :update]

  def create
    @family = FamilyTree.new(family_params.merge(user_id: @user.id))
      if @family.save
          render json: {data:{family_tree: @family},status: :success}
      else
          render json: {"message": @family.errors}, status: :bad_request
      end
  end

  def show
      @family = FamilyTree.find(params[:id])
      render json: {data: {family: @family},status: :success}
  end

  def update
    @family = FamilyTree.find(params[:id])
    if @family.update(family_params)
        render json: {data: {family: @family}, message: "Your family name was succesfully updated"}
    else
        render json: @family.errors
    end
  end

  private

  def family_params
    params.require(:family_tree).permit(:name)
  end
end
