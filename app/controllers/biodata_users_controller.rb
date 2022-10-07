class BiodataUsersController < ApplicationController
    before_action :authorize, only: [:create, :show, :update]
    def create
        @biodata = BiodataUser.new(biodata_params.merge(user_id: @user.id))
        if @biodata.save
            render json: {data:{biodata: @biodata.new_attribute}}
        else
            render json: {"message": @biodata.errors}, status: :bad_request
        end
    end

    def show
        @biodata = BiodataUser.find_by(user_id: @user.id)
        render json: {data:{biodata: @biodata}}
    end

    def update
        @biodata = BiodataUser.find_by(user_id: @user.id)
        if @biodata.update(biodata_params)
            render json: {data: {biodata: @biodata}, message: "Your biodata was succesfully updated"}
        else
            render json: @biodata.errors
        end
    end

    private
    def biodata_params
        params.require(:biodata_user).permit(:email, :dob, :address, :marriage_status, :status)
    end
end 