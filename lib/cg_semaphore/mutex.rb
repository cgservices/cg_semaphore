module CgSemaphore
  class Mutex < OwnedSemaphore
    def initialize name, surpressed=true
      super name, 1, surpressed
    end

    # possibility to override the client
    attr_accessor :client

    @@mutex_class = nil

    def self.mutex_class= mutex_class
      @@mutex_class
    end

    def self.mutex_class mutex_class
      mutex_class = mutex_class
    end

    protected
    def create_semaphore name, size
      semaphore_class = @@owned_semaphore_class || @@semaphore_class
      return semaphore_class.new(name, size) unless semaphore_class.nil?
      @@mutex_class.new name
    end
  end
end
