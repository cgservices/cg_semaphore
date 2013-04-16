module CgSemaphore
  module Officer
    class Semaphore < CgSemaphore.CgSemaphore
      def initialize size, options = {}
        super(size)
        #options.reverse_merge!({:namespace => CgSemaphore.namespace, :host => CgSemaphore.officer_host, :port => CgSemaphore.officer_port})
        # CgSemaphore.client ||= Officer::Client.new :namespace => options[:namespace], :host => options[:host], :port => options[:port]
      end
    end
  end
end