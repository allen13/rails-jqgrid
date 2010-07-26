# Uninstall hook code here

FileUtils.rm_f(
  File.join(RAILS_ROOT,"app/controllers/grid_data_controller.rb"),
  :verbose => true
)

FileUtils.rm_rf(
  File.join(RAILS_ROOT,"public/javascripts/jqgrid"),
  :verbose => true
)

FileUtils.rm_rf(
  File.join(RAILS_ROOT,"public/stylesheets/jqgrid"),
  :verbose => true
)
