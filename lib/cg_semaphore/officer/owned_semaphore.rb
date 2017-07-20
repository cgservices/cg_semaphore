module CgSemaphore
  module Officer
    class OwnedSemaphore
      include CgSemaphore::Semaphorify

      # possibility to override the client
      attr_accessor :client

      def lock
        timeout = Officer.timeout
        response = proper_client.lock build_name, { timeout: timeout }

        result = response['result']
        queue = (response['queue'] || []).join ','

        raise ::Officer::LockTimeoutError.new("name=#{build_name}, timeout=#{timeout}, queue=#{queue}") if result == 'timed_out'
        raise ::Officer::LockQueuedMaxError.new("name=#{build_name}, timeout=#{timeout}, queue=#{queue}") if result == 'queue_maxed'
        raise ::Officer::LockError unless %w(acquired already_acquired).include?(result)

        return response['id'] if response.key?('id')
      end

      def try_lock
        response = proper_client.lock build_name, { timeout: Officer.timeout, queue_max: @size }
        if lock_acquired?(response)
          return response.key?('id') ? response['id'] : true
        end
        false
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

      private

      def lock_acquired?(response)
        response['name'] == build_name && response['result'] == "acquired"
      end
    end
  end
end
