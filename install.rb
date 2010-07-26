# Install grid controller by creating a link to it

FileUtils.cp(
  File.join(RAILS_ROOT,"vendor/plugins/rails-jqgrid/app/controllers/grid_data_controller.rb"),
  File.join(RAILS_ROOT,"app/controllers"),
  :verbose => true
)

FileUtils.cp_r(
  File.join(RAILS_ROOT,"vendor/plugins/rails-jqgrid/public/javascripts/jqgrid"),
  File.join(RAILS_ROOT,"public/javascripts"),
  :verbose => true
)

FileUtils.cp_r(
  File.join(RAILS_ROOT,"vendor/plugins/rails-jqgrid/public/stylesheets/jqgrid"),
  File.join(RAILS_ROOT,"public/stylesheets"),
  :verbose => true
)
