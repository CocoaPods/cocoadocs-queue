class Queue
  
  class << self
    
    attr_accessor :workers
  
    # Start queueing.
    #
    def start
      fork do
        require_queue_libs
        loop do
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
        
          # Call a worker.
          #
          trigger_a_worker pod
          
          # Do not hit workers too often. 
          #
          sleep 5
        end
      end
    end
    
    def require_queue_libs
      Bundler.require(:queue)
    end
    
    def oldest_queued_at_pod
      pods_with_cocoadocs_metrics.
        order_by(:queued_at.asc).
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
        order_by(:updated_at.desc)
    end
    
    def trigger_a_worker name
      puts "Trigger cocoadocs work on pod #{name}:"
      
      # if response.success?
      #   puts "SUCCESS"
      # else
      #   puts "FAIL. Trying next worker."
      # end
    end
    
    def pods_with_cocoadocs_metrics
      Domain.pods.
        outer_join(Domain.cocoadocs_pod_metrics).
        on(:id => :pod_id)
    end
    
  end
  
end