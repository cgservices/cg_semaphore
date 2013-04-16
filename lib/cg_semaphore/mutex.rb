module CgSemaphore
  class Mutex < Semaphore
    def initialize
      super(1)
    end
  end
end