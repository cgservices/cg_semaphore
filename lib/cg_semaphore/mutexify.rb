module CgSemaphore
  module Mutexify
    extend Semaphorify

    def self.included base
      Semaphorify.included base

      base.class_exec do

        # overwrite initialize to ensure size is always 1
        alias_method :semaphorify_initialize, :initialize
        def initialize name
          semaphorify_initialize name, 1
        end
      end
    end
  end
end