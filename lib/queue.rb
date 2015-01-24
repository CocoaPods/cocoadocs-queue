class Queue
  
  class << self
    
    attr_accessor :workers_urls
  
    # Start queueing.
    #
    def start
      $stdout.puts "Starting queue."
      fork do
        $stdout.sync = true
        $stderr.sync = true
        require_queue_libs
        loop do
          begin
            pod = next_eligible_pod
        
            # Call a worker.
            #
            trigger_a_worker(pod) if pod
          
            # Do not hit workers too often. 
            #
            sleep 5
          rescue StandardError => e
            $stderr.puts e.message
          end
        end
      end
    end
    
    def require_queue_libs
      Bundler.require(:queue)
    end
    
    def next_eligible_pod
      # Get the pod with the oldest queued_at.
      pod = oldest_queued_at_pod
  
      # If there is none, get an undocumented pod.
      unless pod
        pod = most_recent_undocumented_pod
      end
  
      # If there are only documented pods which are
      # not queued then just get the pod with the most
      # recent updated_at.
      unless pod
        pod = most_recent_pod
      end
      
      pod
    end
    
    def oldest_queued_at_pod
      pods_with_cocoadocs_metrics.
        order_by(Domain.cocoadocs_pod_metrics[:queued_at].asc).
        first
    end
    
    def most_recent_undocumented_pod
      most_recent_pods.
        where(:pod_id => nil).
        first
    end
    
    def most_recent_pod
      most_recent_pods.first
    end
    
    def most_recent_pods
      pods_with_cocoadocs_metrics.
        order_by(
          Domain.cocoadocs_pod_metrics[:updated_at].desc)
    end
    
    def trigger_a_worker pod
      update_queued_at(pod)
      
      $stdout.print "Trigger cocoadocs work on pod #{pod.name}: "
      
      workers_urls.each do |url|
        response = call_worker(url)
        if response.success?
          $stdout.print "SUCCESS"
          break
        else
          $stdout.print "FAIL. Trying next worker."
        end
      end
      $stdout.puts
    end
    
    def update_queued_at pod
      now = Time.now
      metrics = Domain.cocoadocs_pod_metrics
      if pod.cocoadocs_pod_metric.pod_id
        metrics.
          update(:queued_at => now).
          where(:pod_id => pod.id).
          kick
      else
        metrics.
          insert(
            :pod_id => pod.id,
            :queued_at => now
          ).
          kick
      end
    end
    
    # Calls the given URL.
    #
    def call_worker url
      
    end
    
    def pods_with_cocoadocs_metrics
      Domain.pods.
        outer_join(Domain.cocoadocs_pod_metrics).
        on(:id => :pod_id)
    end
    
  end
  
end