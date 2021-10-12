# Load the Rails application.
require_relative "application"

Rails.application.configure do
  config.hosts << "backend" # Whitelist one hostname
end

# Initialize the Rails application.
Rails.application.initialize!
