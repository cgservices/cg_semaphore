require 'officer'
require 'cg_semaphore/semaphore'
require 'cg_semaphore/mutex'

module CgSemaphore
  mattr_accessor :namespace, :officer_host, :officer_port
end