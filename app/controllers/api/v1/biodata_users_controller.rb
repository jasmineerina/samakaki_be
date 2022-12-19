class Api::V1::BiodataUsersController < ApplicationController
    before_action :authorize, only: [:create, :show, :update,:find_one]
    before_action :set_biodata, only: [:show,  :update]
    before_action :verif_email, only: [:update]

    before_action do
      ActiveStorage::Current.url_options = { protocol: request.protocol, host: request.host, port: request.port }
    end
    def create
        @biodata = BiodataUser.new(biodata_params.merge(user_id: @user.id))
        @biodata.save ? response_to_json({biodata:@biodata.new_attribute}, :success) : response_error(@biodata.errors, :unprocessable_entity)
    end

    def show
        response_to_json({biodata:@biodata.new_attribute}, :success)
    end

    def update
        if params[:name] || params[:phone]
            @user_detail.update(user_params)
            @biodata.update(biodata_params) ? response_to_json(@biodata.new_attribute, :success) : response_error(@biodata.errors, :unprocessable_entity)
        else
            @biodata.update(biodata_params) ? response_to_json(@biodata.new_attribute, :success) : response_error(@biodata.errors, :unprocessable_entity)
        end
    end

    def find_one
        @biodata = BiodataUser.find_one_family(@user,params[:id])
        @biodata ? response_to_json(@biodata,:ok) : response_error("biodata tidak ditemukan atau biodata di private",:not_found)
    end

    private

    def biodata_params
        params.permit(:dob, :address, :marriage_status, :status, :avatar)
    end

    def user_params
        params.permit(:name,:phone,:email)
    end

    def set_biodata
        @user_detail = User.find_by_id(@user.id)
        response_error("user not found", :not_found) unless @user_detail.presence
        @biodata = BiodataUser.find_by(user_id: @user.id)
        response_to_json({message:"biodata tidak ditemukan", biodata: @biodata}, :ok) unless @biodata.presence
    end

end
