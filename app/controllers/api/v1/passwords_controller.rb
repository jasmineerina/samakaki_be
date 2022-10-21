class Api::V1::PasswordsController < ApplicationController
  def forgot
    if params[:email].blank? # check if email is present
      return render json: {error: "Email not present"}
    end

    user = User.find_by(email: params[:email]) # if present find user by email

    if user.present?
      user.generate_password_token! #generate pass token
      # SEND EMAIL HERE
      UserMailer.welcome_email(user).deliver_now
      response_to_json("Token sudah dikirimkan ke email anda",:success)
    else
      response_error("Email tidak dapat ditemukan",:not_found)
    end
  end

  def reset
    token = params[:token].to_s

    if params[:email].blank?
      return render json: {error: "Token not present"}
    end

    user = User.find_by(reset_password_token: token)

    if user.present? && user.password_token_valid?
      if user.reset_password!(params[:password])
        binding.pry
        response_to_json("Password berhasil diubah",:success)
      else
        response_error("Password tidak dapat sama dengan password yang lama",:unprocessable_entity)
      end
    else
      response_error("Token invalid, Coba generate ulang token",:unprocessable_entity)
    end
  end
end
