Bundler.require(*[:default, :web, ENV['RACK_ENV'].to_sym].compact)

require 'json'
require 'sinatra/base'

class QueueApp < Sinatra::Base
  #
  get "/api/v1/pods/:name/enqueue" do
    name = params[:name]
    if name
      pod = Domain.pods.
        outer_join(Domain.cocoadocs_pod_metrics).
          on(:id => :pod_id).
        where(Domain.pods[:name] => name).
        first
      if pod
        Queue.update_queued_at(pod)
        body "Pod #{name} enqueued."
      else
        status 404
      end
    else
      status 404
    end
  end
end
