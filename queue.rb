require_relative 'lib/queue'

Queue.workers_urls = [
  # Add CD worker URLs to call here.
]

Queue.start
