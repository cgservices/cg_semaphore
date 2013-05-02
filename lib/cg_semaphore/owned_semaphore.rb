module CgSemaphore
  class OwnedSemaphore < Semaphore

    @@owned_semaphore_class = nil

    def self.owned_semaphore_class
      @@owned_semaphore_class
    end

    def self.owned_semaphore_class= owned_semaphore_class
      @@owned_semaphore_class = owned_semaphore_class
    end

    protected
    def create_semaphore name, size
      semaphore_class = @@owned_semaphore_class || @@semaphore_class
      semaphore_class.new name, size
    end

  end
end