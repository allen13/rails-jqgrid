# Install grid controller by creating a link to it

FileUtils.ln_s(
  File.join(RAILS_ROOT,"vendor/plugins/rails-jqgrid/app/controllers/grid_data_controller.rb"),
  File.join(RAILS_ROOT,"app/controllers"),
  :verbose => true
)
