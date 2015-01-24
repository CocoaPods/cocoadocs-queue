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
        now = Time.now
        Domain.cocoadocs_pod_metrics.
          update(:queued_at => now).
          where(:pod_id => pod.id).
          kick
        body "Pod #{name} queued at #{now}"
      else
        status 404
      end
    else
      status 404
    end
  end
end
