class Api::V1::EventsController < ApplicationController
    before_action :authorize, only: [:create, :show, :destroy]

    def index
        @events = Event.where(family_tree_id: params[:family_tree_id])
        render json: {data: {events: @events}, status: :success}
    end

    def create
        @event = Event.new(event_params.merge(user_id: @user.id))
        if @event.save
            render json: {data:{event: @event}, status: :success}
        else
            render json: {"message": @event.errors}, status: :bad_request
        end
    end

    def show
        @event = Event.find(params[:id])
        render json: {data: {event: @event}, status: :success}
    end

    def destroy
        @event = Event.find_by_id(params[:id]).destroy
        render json: {data: {event: @event}, message: "The event succesfully deleted"}
    end

    private
    def event_params
        params.permit(:name, :date, :venue, :family_tree_id)
    end
end
