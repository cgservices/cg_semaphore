module CgSemaphore
  class Mutex < Semaphore
    def initialize
      @size = 1
    end
  end
end