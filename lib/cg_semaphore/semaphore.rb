module CgSemaphore
  class Semaphore
    attr_accessor :size
    cattr_accessor :client

    def initialize size, options={}
      options.reverse_merge!({:namespace => CgSemaphore.namespace, :host, CgSemaphore.officer_host, :port => CgSemaphore.officer_port})
      CgSemaphore.client ||= Officer::Client.new :namespace => options[:namespace], :host => options[:host], :port => options[:port]
    end

    def lock name
    end

    def try_lock name
    end

    def unlock name
    end

    def with_lock name
    end

    def with_try_lock name
    end
  end
end