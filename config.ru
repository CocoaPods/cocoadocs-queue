Bundler.require(:default, ENV['RACK_ENV'].to_sym)

# Load globally needed configs.
#
require_relative 'config/database'

# Start queueing process.
#
require_relative 'queue'

# Load web app.
#
require File.expand_path('../web/app', __FILE__)

# Run web app.
#
run QueueApp
