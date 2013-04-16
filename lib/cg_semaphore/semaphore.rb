module CgSemaphore
  class Semaphore
    attr_accessor :size

    def initialize size
      @size = size
    end

    def lock name
      raise "lock not implemented"
    end

    def try_lock name
      raise "try_lock not implemented"
    end

    def unlock name
      raise "unlock not implemented"
    end

    def with_lock name
      raise_unlock_exception = true

      lock name

      begin
        yield
      rescue Exception
        # Exception rescued during yield. Any unlock exception may not be re-raised, as this exception was raised first.
        raise_unlock_exception = false

        # Re-raise the rescued exception
        raise
      ensure
        begin
          unlock name
        rescue Exception
          # Exception rescued while unlocking. Only re-raise this if no exception was rescued during yield.
          raise if raise_unlock_exception
        end
      end
    end

    def with_try_lock name
      raise_unlock_exception = true

      if try_lock name
        begin
          yield
        rescue Exception
          # Exception rescued during yield. Any unlock exception may not be re-raised, as this exception was raised first.
          raise_unlock_exception = false

          # Re-raise the rescued exception
          raise
        ensure
          begin
            unlock name
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