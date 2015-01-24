# Start queueing process.
#
require 'queue'

# Load web app.
#
require File.expand_path('../web/app', __FILE__)

# Run web app.
#
run QueueApp
