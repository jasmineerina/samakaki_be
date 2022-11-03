class Api::V1::RelationsController < ApplicationController
  before_action :authorize, only: [:create, :update]

  def create
    @family = FamilyTree.find_by_id(params[:family_tree_id])
    if @family.presence
    @relation_detail=Relation.relation_detail(params[:relation_name])
    @relation = Relation.new(relation_params.merge(position:@relation_detail[0][:position],number:@relation_detail[0][:number],user_id:@user.id,family_tree_id: params["family_tree_id"],connected_user_id:params["connected_user_id"],status:"non_active"))
    @relation.save ? response_to_json(@relation.get_relation_from_invitation, :success) : response_error(@relation.errors, :unprocessable_entity)
    else
      response_error("family tidak ditemukan", :not_found)
    end
  end

  def update
    @relation = Relation.find(params[:id])
    @relation.update(relation_params) ? response_to_json({relation: @relation,message:"berhasil update relation"}, :success) : response_error(@relation.errors,:unprocessable_entity)
  end

  private

  def relation_params
    # @relation_params = Relation.relation(params[:relation_name])
    params.require(:relation).permit(:name,:relation_name)
  end
end


