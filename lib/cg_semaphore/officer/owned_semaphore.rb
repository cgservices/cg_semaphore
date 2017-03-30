module CgSemaphore
  module Officer
    class OwnedSemaphore
      include CgSemaphore::Semaphorify

      # possibility to override the client
      attr_accessor :client

      def lock
        response = proper_client.lock build_name, {:timeout => Officer.timeout}

        result = response['result']
        queue = (response['queue'] || []).join ','

        raise ::Officer::LockTimeoutError.new("queue=#{queue}") if result == 'timed_out'
        raise ::Officer::LockQueuedMaxError.new("queue=#{queue}") if result == 'queue_maxed'
        raise ::Officer::LockError unless %w(acquired already_acquired).include?(result)

        response['id']
      end

      def try_lock
        response = proper_client.lock build_name, {:timeout => Officer.timeout, :queue_max => 1}
        response['name'] == build_name && response['result'] == "acquired"
      end

      def unlock
        proper_client.unlock build_name
      end

      private
        def proper_client
          @client || Officer.client
        end

        def build_name
          "#{@name}|#{@size}"
        end

    end
  end
end
