class BiodataUsersController < ApplicationController
    before_action :authorize, only: [:create, :show, :update]
    def create
        @biodata = BiodataUser.new(biodata_params.merge(user_id: @user.id))
        binding.pry
        if @biodata.save
            render json: {data:{biodata: @biodata.new_attribute}}
        else
            render json: {"message": @biodata.errors}, status: :bad_request
        end
    end

    def show
        @biodata = Biodata.find_by(email: params[:email])
    end

    def update
        @biodata = Biodata.find_by email: current_user.email
        if @biodata.update(biodata_params)
            flash[:notices] = ["Your biodata was succesfully updated"]
            render json: @biodata.new_attribute
        else
            flash[:notices] = ["Your biodata could not be updated"]
            render json: @biodata.errors
        end
    end

    private
    def biodata_params
        params.require(:biodata_user).permit(:email, :dob, :address, :marriage_status, :status)
    end
end 