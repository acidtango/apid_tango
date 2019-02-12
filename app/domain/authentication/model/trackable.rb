# frozen_string_literal: true

module Authentication
  # Adds tracking capabilities to model
  module Trackable
    def update_tracking_fields(request)
      new_current = Time.now.utc
      self.last_sign_in_at     = current_sign_in_at || new_current
      self.current_sign_in_at  = new_current

      new_current = request.env['action_dispatch.remote_ip'].to_s
      self.last_sign_in_ip     = current_sign_in_ip || new_current
      self.current_sign_in_ip  = new_current

      self.sign_in_count ||= 0
      self.sign_in_count += 1
    end

    def update_tracking_fields!(request)
      update_tracking_fields(request)
      save(validate: false)
    end
  end
end
