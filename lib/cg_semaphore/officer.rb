require 'officer'
require 'cg_semaphore/officer/owned_semaphore'

module CgSemaphore
  module Officer

    # global officer client for all semaphores
    @@client = nil

    # global timeout for officer clients for all semaphores
    @@timeout = nil

    def self.client
      @@client
    end

    def self.client=(client)
      @@client = client
    end

    def self.timeout
      @@timeout
    end

    def self.timeout=(timeout)
      @@timeout = timeout
    end

  end
end
