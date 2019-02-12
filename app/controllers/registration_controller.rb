# frozen_string_literal: true

# handle authorization requests
class RegistrationController < APIController
  default_error_callback :registration_create_error

  # POST /registration
  def create
    Registration::CreateInteractor.new(self, registration_params).call
  end

  def registration_create_success(auth)
    render json: Authentication::LoginPresenter.new(auth), status: :created
  end

  private

  def registration_params
    params.require(
      %i[name username password scope organization_name organization_cif personal_number phone]
    )
    params.permit(:name, :username, :password, :scope, :organization_name, :organization_cif,
                  :personal_number, :phone)
  end
end
