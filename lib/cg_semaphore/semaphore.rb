module CgSemaphore
  class Semaphore
    attr_reader :name
    attr_reader :size

    def initialize name, size
      @name = name
      @size = size
    end

    def lock
      raise "lock not implemented"
    end

    def try_lock
      raise "try_lock not implemented"
    end

    def unlock
      raise "unlock not implemented"
    end

    def with_lock
      raise_unlock_exception = true

      lock

      begin
        yield
      rescue Exception
        # Exception rescued during yield. Any unlock exception may not be re-raised, as this exception was raised first.
        raise_unlock_exception = false

        # Re-raise the rescued exception
        raise
      ensure
        begin
          unlock
        rescue Exception
          # Exception rescued while unlocking. Only re-raise this if no exception was rescued during yield.
          raise if raise_unlock_exception
        end
      end
    end

    def with_try_lock
      raise_unlock_exception = true

      if try_lock
        begin
          yield
        rescue Exception
          # Exception rescued during yield. Any unlock exception may not be re-raised, as this exception was raised first.
          raise_unlock_exception = false

          # Re-raise the rescued exception
          raise
        ensure
          begin
            unlock
          rescue Exception
            # Exception rescued while unlocking. Only re-raise this if no exception was rescued during yield.
            raise if raise_unlock_exception
          end
        end

        # return true to indicate a lock was acquired
        true
      else
        # return false to indicate a lock could not be acquired
        false
      end
    end
  end
end