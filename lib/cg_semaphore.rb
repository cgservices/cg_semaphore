require 'officer'
require 'cg_semaphore/semaphore'
require 'cg_semaphore/mutex'

module CgSemaphore
  @@namespace
  @@officer_host
  @@officer_port

  def self.namespace
    @@namespace ||= "blaat"
  end

  def self.namespace=(ns)
    @@namespace = ns
  end
end