# frozen_string_literal: true

module Users
  # Presenter for user
  class ShowPresenter < Roar::Decorator
    include Roar::JSON::JSONAPI.resource :users, id_key: :public_id

    attributes do
      property :email
      property :name
      property :surnames
      property :personal_number
      property :phone
      nested :sign_in do
        property :sign_in_count, as: :count
        property :current_sign_in_ip, as: 'current-ip', getter: (lambda do |represented:, **|
          represented.current_sign_in_ip.to_s
        end)
        property :current_sign_in_at, as: 'current-at', type: Time
        property :last_sign_in_ip, as: 'last-ip', getter: (lambda do |represented:, **|
          represented.current_sign_in_ip.to_s
        end)
        property :last_sign_in_at, as: 'last-at', type: Time
      end
    end
  end
end
