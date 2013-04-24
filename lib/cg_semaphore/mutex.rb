module CgSemaphore
  class Mutex < OwnedSemaphore
    def initialize name
      super name, 1
    end
  end
end