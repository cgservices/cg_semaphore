module CgSemaphore
  module Officer
    class Mutex < OwnedSemaphore
      include CgSemaphore::Mutexify
    end
  end
end
