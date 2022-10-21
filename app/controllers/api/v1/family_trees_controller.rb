class Api::V1::FamilyTreesController < ApplicationController
  before_action :authorize, only: [:create, :show, :update]
  before_action :set_family, only: [:show,:update]

  def create
    @family = FamilyTree.new(family_params.merge(user_id: @user.id))
    @family.save ? response_to_json({family_name:@family.name}, :success) : response_error(@family.errors, :unprocessable_entity)
  end

  def show
    response_to_json({family_name: @family.name},:success)
  end

  def update
    @family.update(family_params) ? response_to_json({family_name:@family.name}, :success) : response_error(@family.errors, :unprocessable_entity)
  end

  private
  def set_family
    @family = FamilyTree.find_by(id: params[:id])
    response_error("family not found", :not_found) unless @family.presence
  end

  def family_params
    params.require(:family_tree).permit(:name)
  end
end
