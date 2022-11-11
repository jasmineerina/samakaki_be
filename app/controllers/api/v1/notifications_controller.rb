class Api::V1::NotificationsController < ApplicationController
  before_action :authorize, only: [:index]
  before_action :set_notif,only: [:show, :update]
  before_action do
    ActiveStorage::Current.url_options = { protocol: request.protocol, host: request.host, port: request.port }
  end
  def index
    @notif = Notification.get(@user)
    return response_error("Tidak ada notifications", :not_found) unless @notif.presence
    response_to_json(@notif,:success)
  end

  def show
    response_to_json({notif:@notif.new_attribute},:success)
  end

  def update
    @notif.update(status: "read")
    response_to_json({notif:@notif.new_attribute},:success)
  end


  private

  def set_notif
    @notif = Notification.find_by_id(params[:id])
    return response_error("Notification tidak ditemukan", :not_found) unless @notif.presence
  end
end
