require_relative 'lib/queue'
Queue.workers = [
  # Add CD workers here.
]
Queue.start
