# frozen_string_literal: true

module API
  # default i18n settings
  module Translation
    extend ActiveSupport::Concern

    included do
      prepend_before_action :set_locale
    end

    private

    def set_locale
      I18n.locale = extract_locale_from_accept_language_header
    end

    def extract_locale_from_accept_language_header
      header = request.env['HTTP_ACCEPT_LANGUAGE']
      (header && header.scan(/^[a-z]{2}/).first.to_sym) || I18n.default_locale
    end
  end
end
