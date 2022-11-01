module ApplicationCable
  class Connection < ActionCable::Connection::Base
    before_action :authorize, only: [:connect]

    def connect
      self.current_user = find_verified_user
    end

    private
      def find_verified_user
        # or however you want to verify the user on your system
        if @user
          @user
        else
          reject_unauthorized_connection
        end
      end
  end
  end
end
