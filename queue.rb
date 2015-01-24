require File.expand_path('../app', __FILE__)

require_relative '../lib/queue'
Queue.workers = [
  # Add CD workers here.
]
Queue.start
