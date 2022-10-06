class ApplicationController < ActionController::API
    def encode_token(payload,exp=1.days.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, 'secret')
  end

  def decoded_token
    #auth bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjpudWxsfQ.usUC8ObZll751xV7FqJJgL6jemaYjKz8Ll5exP34rPw

    auth_header = request.headers['Authorization']

    if auth_header
      token = auth_header.split(' ')[1]
      begin
        JWT.decode(token, 'secret', true, algorithm: 'HS256')
      rescue JWT::DecodeError
        nil
      end
    end
  end

  def authorized_user
    decoded_token = decoded_token()
    if decoded_token
      email = decoded_token[0]['email']
      @user = User.find_by_email(email)
    end
  end

  def authorize
    render json: {message: 'You have to log in'}, status: :unauthorized unless
    authorized_user
  end
end
