SimpleCov.start 'rails' do
  minimum_coverage 90

  add_group "Models", "app/models"
  add_group "Domain Logic", "app/domain"
  add_group "Libraries", "lib"
  add_group "Controllers", "app/controllers"

  add_filter "/spec/"
  add_filter "/tests/"
  add_filter "/config/"
  add_filter "/vendor/"
  add_filter "/i18n/"

end
