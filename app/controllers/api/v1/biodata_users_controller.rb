class Api::V1::BiodataUsersController < ApplicationController
    before_action :authorize, only: [:create, :show, :update]
    def create
        @biodata = BiodataUser.new(biodata_params.merge(user_id: @user.id))
        @biodata.save ? response_to_json(@biodata.new_attribute, :success) : response_error(@biodata.errors, :unprocessable_entity)
    end

    def show
        @biodata = BiodataUser.find_by(user_id: @user.id)
        render json: {data:{biodata: @biodata.new_attribute,avatar: @biodata.avatar.url}}
    end

    def update
        @biodata = BiodataUser.find_by(user_id: @user.id)
        if @biodata.update(biodata_params)
            render json: {data: {biodata: @biodata.new_attribute}, message: "Your biodata was succesfully updated"}
        else
            render json: @biodata.errors
        end
    end

    private
    def biodata_params
        params.permit(:email, :dob, :address, :marriage_status, :status, :avatar)
    end
end
