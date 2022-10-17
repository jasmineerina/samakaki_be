class Api::V1::EventsController < ApplicationController
    before_action :authorize, only: [:create, :show]

    def create
        @event = Event.new(event_params.merge(user_id: @user.id))
        if @event.save
            render json: {data:{event: @event}, status: :success}
        else
            render json: {"message": @event.errors}, status: :bad_request
        end
    end

    private
    def event_params
        params.permit(:name, :date, :venue, :family_tree_id)
    end
end
