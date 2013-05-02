module CgSemaphore
  class Semaphore
    attr_reader :surpressed
    @@rescue_surpressed_exception = lambda { |e, s| }
    @@semaphore_class = nil

    def initialize name, size, surpressed=true
      @surpressed = surpressed
      @semaphore = create_semaphore name, size
    end

    def self.semaphore_class
      @@semaphore_class
    end

    def self.semaphore_class= semaphore_class
      @@semaphore_class = semaphore_class
    end

    def self.rescue_surpressed_exception &block
      @@rescue_surpressed_exception = block unless block.nil?
      @@rescue_surpressed_exception
    end

    def size
      @semaphore.size
    end

    def name
      @semaphore.name
    end

    def lock
      begin
        @semaphore.lock
      rescue Exception => e
        handle_exception e
      end
    end

    def try_lock
      result = false
      begin
        result = @semaphore.try_lock
      rescue Exception => e
        handle_exception e
        result = true # will only be reached if surpressed
      end
      result
    end

    def unlock
      begin
        @semaphore.unlock
      rescue Exception => e
        handle_exception e
      end
    end

    def with_lock
      yield_exception_rescued = false

      lock

      begin
        yield
      rescue Exception
        # Exception rescued during yield. Any unlock exception may not be re-raised, as this exception was raised first.
        yield_exception_rescued = true

        # Re-raise the rescued exception
        raise
      ensure
        begin
          unlock
        rescue Exception => e
          # Exception rescued while unlocking. Only re-raise this if no exception was rescued during yield.
          handle_exception e unless yield_exception_rescued
        end
      end
    end

    def with_try_lock
      yield_exception_rescued = false

      if try_lock
        begin
          yield
        rescue Exception
          # Exception rescued during yield. Any unlock exception may not be re-raised, as this exception was raised first.
          yield_exception_rescued = true

          # Re-raise the rescued exception
          raise
        ensure
          begin
            unlock
          rescue Exception => e
            # Exception rescued while unlocking. Only re-raise this if no exception was rescued during yield.
            handle_exception e unless yield_exception_rescued
          end
        end

        # return true to indicate a lock was acquired
        true
      else
        # return false to indicate a lock could not be acquired
        false
      end
    end

    protected
      def create_semaphore name, size
        @@semaphore_class.new name, size
      end

      def handle_exception exception
        raise exception unless @surpressed
        self.class.rescue_surpressed_exception.call exception, self
      end

  end
end