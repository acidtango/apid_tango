# frozen_string_literal: true

module Registration
  # registration logic
  class CreateInteractor < BaseInteractor
    extend Forwardable
    steps :build, :apply, :login

    def_delegators :callee, :request

    attr_accessor :name, :username, :password, :scope, :organization_name, :organization_cif,
                  :personal_number, :phone, :auth

    def build
      self.username = username.downcase
      return push_email_already_exists_error if current_user&.role?(scope)

      current_user || User.new(user_params)
    end

    def apply(user)
      role = Role.find_by(name: scope)
      user.roles << role
      user.save

      validate_active_record_object user
    end

    def login(_user)
      Authentication::LoginInteractor.new(self, username: username, password: password).call
    end

    def authentication_login_success(auth)
      self.auth = auth
    end

    def authentication_login_error(error)
      errors.push(error)
    end

    private

    def push_email_already_exists_error
      errors.push(Errors::ResourceAlreadyExists
                          .new(I18n.t('domain.users.registration.create_error')))
    end

    def current_user
      @current_user ||= User.joins(:roles).find_by(email: username)
    end

    def organization
      @organization ||= Organization.create_with(public_id: public_id(Organization),
                                                 name: organization_name)
                                    .find_or_create_by(cif: organization_cif.upcase)
    end

    def user_params
      { name: name, email: username, password: password, organization: organization,
        personal_number: personal_number, phone: phone, public_id: public_id(User) }
    end

    def public_id(model)
      loop do
        public_id = SecureRandom.hex 6
        return public_id unless model.where(public_id: public_id).exists?
      end
    end
  end
end
