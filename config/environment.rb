# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Use SafeYaml in secure mode
SafeYAML::OPTIONS[:default_mode] = :safe

# Initialize the Rails application.
MotorrijweerV3::Application.initialize!
