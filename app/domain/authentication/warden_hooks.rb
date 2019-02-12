# frozen_string_literal: true

# After each sign in, update sign in time, sign in count and sign in IP.
# This is only triggered when the user is explicitly set (with set_user)
# and on authentication. Retrieving the user from session (:fetch) does
# not trigger it.
# (Taken from Devise)
Warden::Manager.after_set_user(except: :fetch) do |record, warden, options|
  if record.respond_to?(:update_tracking_fields!) &&
     warden.authenticated?(options[:scope])
    record.update_tracking_fields!(warden.request)
  end
end
