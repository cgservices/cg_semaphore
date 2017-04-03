require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')
require 'cg_semaphore/officer'

CgSemaphore::OwnedSemaphore.owned_semaphore_class = ::CgSemaphore::Officer::OwnedSemaphore

describe CgSemaphore::Officer::Mutex do
  before do
    @server = Officer::Server.new :stats => true # :log_level => "debug"
    @server.instance_variable_set("@enable_shutdown_port", true)
    @server_thread = Thread.new {@server.run}

    CgSemaphore::Officer.client = Officer::Client.new
    @mutex = CgSemaphore::Mutex.new "testlock"

    # using mutex with an other client for testing
    @testMutex = CgSemaphore::Mutex.new "testlock"
    @testMutex.client = Officer::Client.new

    # wait until the server is running
    while !@server.running?; end
  end

  after do
    shutdown_socket = TCPSocket.new("127.0.0.1", 11501)
    shutdown_socket.close

    CgSemaphore::Officer.client.disconnect
    CgSemaphore::Officer.client = nil

    # wait until the server is stopped
    while @server.running?; end
  end

  describe "#with_lock" do
    it "should execute the block" do
      block_executed = false
      @mutex.with_lock { block_executed = true }
      block_executed.should be_true
    end

    it "should prevent another mutex instance with same name to lock" do
      @mutex.with_lock { @testMutex.try_lock.should be_false }
    end

    it "should allow another mutex instance with same name to lock afterwards" do
      @mutex.with_lock { }
      @testMutex.try_lock.should be_true
    end
  end

end
