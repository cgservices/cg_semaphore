module CgSemaphore
  module Officer
    class OwnedSemaphore < CgSemaphore::OwnedSemaphore

      attr_accessor :client

      def lock
        proper_client.lock build_name, {:timeout => Officer.timeout}
      end

      def try_lock
        result = proper_client.lock build_name, {:timeout => Officer.timeout, :queue_max => 1}
        result['name'] == build_name && result['result'] == "acquired"
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