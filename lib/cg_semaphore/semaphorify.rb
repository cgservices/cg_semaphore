module CgSemaphore
  module Semaphorify
    def self.included base
      base.class_exec do

        attr_reader :name
        attr_reader :size

        def initialize name, size
          @name = name
          @size = size
        end

        def sinitialize name, size
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
            rescue Exception
              # Exception rescued while unlocking. Only re-raise this if no exception was rescued during yield.
              raise unless yield_exception_rescued
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
              rescue Exception
                # Exception rescued while unlocking. Only re-raise this if no exception was rescued during yield.
                raise unless yield_exception_rescued
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
  end
end