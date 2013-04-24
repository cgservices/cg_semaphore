require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')
require 'cg_semaphore/officer'

describe CgSemaphore::Officer::OwnedSemaphore do
  before do
    @server = Officer::Server.new :stats => true # :log_level => "debug"
    @server.instance_variable_set("@enable_shutdown_port", true)
    @server_thread = Thread.new {@server.run}

    CgSemaphore::Officer.client = Officer::Client.new
    @semaphore = CgSemaphore::Officer::OwnedSemaphore.new "testlock", 1

    # using semaphore with an other client for testing
    @testSemaphore = CgSemaphore::Officer::OwnedSemaphore.new "testlock", 1
    @testSemaphore.client =  Officer::Client.new

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

  describe "#lock" do
    it "should succeed to lock" do
      @semaphore.try_lock.should be_true
    end

    it "should prevent another semaphore with same name to lock" do
      @semaphore.lock
      @testSemaphore.try_lock.should be_false
    end
  end

  describe "#try_lock" do
    it "should succeed to lock" do
      @semaphore.try_lock.should be_true
    end

    it "should prevent another semaphore with same name to lock" do
      @semaphore.try_lock
      @testSemaphore.try_lock.should be_false
    end
  end

  describe "#unlock" do
    context "when locked" do
      it "should allow another semaphore with same name to lock" do
        @semaphore.lock
        @semaphore.unlock
        @testSemaphore.try_lock.should be_true
      end
    end

    context "when try_locked" do
      it "should allow another semaphore with same name to lock" do
        @semaphore.try_lock
        @semaphore.unlock
        @testSemaphore.try_lock.should be_true
      end
    end
  end

  describe "#with_lock" do
    it "should execute the block" do
      block_executed = false
      @semaphore.with_lock { block_executed = true }
      block_executed.should be_true
    end

    it "should prevent another semaphore with same name to lock" do
      @semaphore.with_lock { @testSemaphore.try_lock.should be_false }
    end

    it "should allow another semaphore with same name to lock afterwards" do
      @semaphore.with_lock { }
      @testSemaphore.try_lock.should be_true
    end
  end

  describe "#with_try_lock" do
    it "should execute the block" do
      block_executed = false
      @semaphore.with_try_lock { block_executed = true }
      block_executed.should be_true
    end

    it "should prevent another semaphore with same name to lock" do
      @semaphore.with_try_lock { @testSemaphore.try_lock.should be_false }
    end

    it "should allow another semaphore with same name to lock afterwards" do
      @semaphore.with_try_lock { }
      @testSemaphore.try_lock.should be_true
    end
  end
end