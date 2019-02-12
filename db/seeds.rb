# frozen_string_literal: true

# apid_tango organization
Organization.create_with(public_id: SecureRandom.hex(6))
            .find_or_create_by!(name: 'Apid Tango', cif: '123456')

# roles
%w[supplier client operations].each do |role|
  Role.find_or_create_by(name: role)
end
