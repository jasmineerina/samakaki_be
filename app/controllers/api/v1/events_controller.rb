class Api::V1::EventsController < ApplicationController
    before_action :authorize, only: [:create, :show, :destroy, :update, :index]
    before_action :set_event, only: [:show,:destroy, :update]

    def index
        @events = Event.get_all(@user)
        response_to_json({events:@events},:success)
    end

    def create
        @event = Event.new(event_params.merge(user_id: @user.id,date: "#{params[:date]} #{params[:time]}.000+00:00"))
        @event.save ? response_to_json({event:@event.event_attribute}, :success) : response_error(@event.errors, :unprocessable_entity)
    end

    def show
        response_to_json({event:@event.event_attribute},:success)
    end

    def destroy
        @event.destroy
        response_to_json({event:@event,message:"Berhasil menghapus event"},:success)
    end

    def update
        @event.update(event_params )? response_to_json({event:@event},:success):response_error(@event.errors,:unprocessable_entity)
    end

    private

    def set_event
        @event = Event.find_by(id: params[:id])
        response_error("event not found", :not_found) unless @event.presence
    end

    def event_params
        params.require(:event).permit(:name, :venue)
    end
end
