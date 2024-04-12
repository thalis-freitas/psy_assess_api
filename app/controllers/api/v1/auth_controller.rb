class Api::V1::AuthController < Api::V1::ApiController
  def login
    @user = User.find_by(email: login_params[:email])

    if @user&.authenticate(login_params[:password])
      user_json = @user.as_json(only: %i[id email name role])

      render json: { user: user_json,
                     token: encode_token({ user_id: @user.id }) }, status: :ok
    else
      render json: { errors: I18n.t('errors.login_or_password_invalid') },
             status: :unprocessable_entity
    end
  end

  private

  def login_params
    params.require(:user).permit(:email, :password)
  end
end
