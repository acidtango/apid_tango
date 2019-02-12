# frozen_string_literal: true

# handle authorization requests
class AuthenticationController < APIController
  default_error_callback :authentication_login_error, :authentication_refresh_token_error

  # POST /auth
  def create
    Authentication::LoginInteractor.new(self, auth_params).call
  end

  def authentication_login_success(auth)
    render json: Authentication::LoginPresenter.new(auth), status: :created
  end

  # PATCH /auth
  def update
    Authentication::RefreshTokenInteractor.new(self).call
  end

  def authentication_refresh_token_success(auth)
    authentication_login_success(auth)
  end

  private

  def auth_params
    params.require(%i[username password])
    params.permit(:username, :password)
  end
end
