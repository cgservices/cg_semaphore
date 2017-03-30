require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe CgSemaphore::Semaphore do
  before do
    class SemaphoriedDummyClass
      include CgSemaphore::Semaphorify
    end

    CgSemaphore::Semaphore.semaphore_class = SemaphoriedDummyClass
    @semaphore = CgSemaphore::Semaphore.new "testlock", 3, false
    @wrappedSemaphore = @semaphore.instance_variable_get('@semaphore')
  end

  describe "#size" do
    it "should have the same value as upon initializing" do
      @semaphore.size.should == 3
    end
  end

  describe "#name" do
    it "should have the same value as upon initializing" do
      @semaphore.name.should == "testlock"
    end
  end

  describe "#lock" do
    it "should call lock on wrapped semaphore" do
      @wrappedSemaphore.stub(:lock) { }
      @semaphore.should_receive(:lock).once
      @semaphore.lock
    end

    it "should store the lock index" do
      @wrappedSemaphore.stub(:lock) { '0' }
      @semaphore.lock
      @semaphore.lock_index.should eq '0'
    end
  end

  describe "#try_lock" do
    it "should call try_lock on wrapped semaphore" do
      @wrappedSemaphore.stub(:try_lock) { false }
      @semaphore.should_receive(:try_lock).once
      @semaphore.try_lock
    end
  end

  describe "#unlock" do
    it "should call unlock on wrapped semaphore" do
      @wrappedSemaphore.stub(:unlock) { }
      @semaphore.should_receive(:unlock).once
      @semaphore.unlock
    end
  end

  context "unsurpressed" do
    describe "#lock" do
      it "should forward the exception" do
        @wrappedSemaphore.stub(:lock) { raise StandardError.new('This exception should be forwarded.')  }
        expect { @semaphore.lock }.to raise_exception(StandardError, 'This exception should be forwarded.')
      end
    end

    describe "#try_lock" do
      it "should forward the exception" do
        @wrappedSemaphore.stub(:try_lock) { raise StandardError.new('This exception should be forwarded.')  }
        expect { @semaphore.try_lock }.to raise_exception(StandardError, 'This exception should be forwarded.')
      end
    end

    describe "#with_lock" do
      it "should execute the block if lock succeeds" do
        @wrappedSemaphore.stub(:lock) { true }
        @wrappedSemaphore.stub(:unlock) { true }
        block_executed = false

        begin
          @semaphore.with_lock { block_executed = true }
        rescue
        end
        block_executed.should be_true
      end

      it "should not execute the block if lock raises an exception" do
        @wrappedSemaphore.stub(:lock) { raise "error" }
        @wrappedSemaphore.stub(:unlock) { true }
        block_executed = false

        begin
          @semaphore.with_lock { block_executed = true }
        rescue
        end
        block_executed.should be_false
      end

      it "should forward the block exception" do
        @wrappedSemaphore.stub(:lock) { true }
        @wrappedSemaphore.stub(:unlock) { true }
        expect { @semaphore.with_lock { raise StandardError.new("block exception") }}.to raise_exception(StandardError, "block exception")
      end
    end

    describe "#with_try_lock" do
      it "should execute the block if try_lock succeeds" do
        @wrappedSemaphore.stub(:try_lock) { true }
        @wrappedSemaphore.stub(:unlock) { true }
        block_executed = false

        begin
          @semaphore.with_try_lock { block_executed = true }
        rescue
        end
        block_executed.should be_true
      end

      it "should not execute the block if try_lock raises an exception" do
        @wrappedSemaphore.stub(:lock) { raise "error" }
        @wrappedSemaphore.stub(:unlock) { true }
        block_executed = false

        begin
          @semaphore.with_lock { block_executed = true }
        rescue
        end
        block_executed.should be_false
      end

      it "should forward the block exception" do
        @wrappedSemaphore.stub(:try_lock) { true }
        @wrappedSemaphore.stub(:unlock) { true }
        expect { @semaphore.with_try_lock { raise StandardError.new("block exception") }}.to raise_exception(StandardError, "block exception")
      end
    end

    describe "#unlock" do
      it "should forward the exception" do
        @wrappedSemaphore.stub(:unlock) { raise StandardError.new('This exception should be forwarded.')  }
        expect { @semaphore.unlock }.to raise_exception(StandardError, 'This exception should be forwarded.')
      end
    end
  end

  context "surpressed" do
    before do
      @semaphore.instance_variable_set('@surpressed', true)
    end

    describe "#lock" do
      it "should surpress the exception" do
        @wrappedSemaphore.stub(:lock) { raise StandardError.new('This exception should be surpressed.') }
        expect { @semaphore.lock }.to_not raise_exception
      end

      it "should pass the lock exception to handler" do
        block_exception = StandardError.new('This exception should be surpressed.')
        rescued_surpressed_exception = nil
        CgSemaphore::Semaphore.rescue_surpressed_exception { |e, s| rescued_surpressed_exception = e }

        @wrappedSemaphore.stub(:lock) { raise block_exception }
        @semaphore.lock

        expect(rescued_surpressed_exception).to eq block_exception
      end
    end

    describe "#try_lock" do
      it "should surpress the exception" do
        @wrappedSemaphore.stub(:try_lock) { raise StandardError.new('This exception should be surpressed.') }
        expect { @semaphore.try_lock }.to_not raise_exception
      end

      it "should pass the try_lock exception to handler" do
        block_exception = StandardError.new('This exception should be surpressed.')
        rescued_surpressed_exception = nil
        CgSemaphore::Semaphore.rescue_surpressed_exception { |e, s| rescued_surpressed_exception = e }

        @wrappedSemaphore.stub(:try_lock) { raise block_exception }
        @semaphore.try_lock

        expect(rescued_surpressed_exception).to eq block_exception
      end
    end

    describe "#with_lock" do
      it "should execute the block if lock succeeds" do
        @wrappedSemaphore.stub(:lock) { true }
        @wrappedSemaphore.stub(:unlock) { true }
        block_executed = false

        begin
          @semaphore.with_lock { block_executed = true }
        rescue
        end
        block_executed.should be_true
      end

      it "should execute the block if lock raises an exception" do
        @wrappedSemaphore.stub(:lock) { raise "error" }
        @wrappedSemaphore.stub(:unlock) { true }
        block_executed = false

        begin
          @semaphore.with_lock { block_executed = true }
        rescue
        end
        block_executed.should be_true
      end

      it "should forward the block exception" do
        @wrappedSemaphore.stub(:lock) { true }
        @wrappedSemaphore.stub(:unlock) { true }
        expect { @semaphore.with_lock { raise StandardError.new("block exception") }}.to raise_exception(StandardError, "block exception")
      end

      it "should pass the lock exception to handler" do
        block_exception = StandardError.new('This exception should be surpressed.')
        rescued_surpressed_exception = nil
        CgSemaphore::Semaphore.rescue_surpressed_exception { |e, s| rescued_surpressed_exception = e }

        @wrappedSemaphore.stub(:lock) { raise block_exception }
        @wrappedSemaphore.stub(:unlock) { true }
        @semaphore.with_lock { }

        expect(rescued_surpressed_exception).to eq block_exception
      end

      it "should pass the unlock exception to handler" do
        unlock_exception = StandardError.new('This exception should be surpressed.')
        rescued_surpressed_exception = nil
        CgSemaphore::Semaphore.rescue_surpressed_exception { |e, s| rescued_surpressed_exception = e }

        @wrappedSemaphore.stub(:lock) { true }
        @wrappedSemaphore.stub(:unlock) { raise unlock_exception }
        @semaphore.with_lock { }

        expect(rescued_surpressed_exception).to eq unlock_exception
      end
    end

    describe "#with_try_lock" do
      it "should execute the block if try_lock succeeds" do
        @wrappedSemaphore.stub(:try_lock) { true }
        @wrappedSemaphore.stub(:unlock) { true }
        block_executed = false

        begin
          @semaphore.with_lock { block_executed = true }
        rescue
        end
        block_executed.should be_true
      end

      it "should execute the block if try_lock raises an exception" do
        @wrappedSemaphore.stub(:try_lock) { raise "error" }
        @wrappedSemaphore.stub(:unlock) { true }
        block_executed = false

        begin
          @semaphore.with_try_lock { block_executed = true }
        rescue
        end
        block_executed.should be_true
      end

      it "should forward the block exception" do
        @wrappedSemaphore.stub(:try_lock) { true }
        @wrappedSemaphore.stub(:unlock) { true }
        expect { @semaphore.with_try_lock { raise StandardError.new("block exception") }}.to raise_exception(StandardError, "block exception")
      end

      it "should pass the try_lock exception to handler" do
        block_exception = StandardError.new('This exception should be surpressed.')
        rescued_surpressed_exception = nil
        CgSemaphore::Semaphore.rescue_surpressed_exception { |e, s| rescued_surpressed_exception = e }

        @wrappedSemaphore.stub(:try_lock) { raise block_exception }
        @wrappedSemaphore.stub(:unlock) { true }
        @semaphore.with_try_lock { }

        expect(rescued_surpressed_exception).to eq block_exception
      end

      it "should pass the unlock exception to handler" do
        unlock_exception = StandardError.new('This exception should be surpressed.')
        rescued_surpressed_exception = nil
        CgSemaphore::Semaphore.rescue_surpressed_exception { |e, s| rescued_surpressed_exception = e }

        @wrappedSemaphore.stub(:try_lock) { true }
        @wrappedSemaphore.stub(:unlock) { raise unlock_exception }
        @semaphore.with_try_lock { }

        expect(rescued_surpressed_exception).to eq unlock_exception
      end
    end

    describe "#unlock" do
      it "should surpress the exception" do
        @wrappedSemaphore.stub(:unlock) { raise StandardError.new('This exception should be surpressed.') }
        expect { @semaphore.unlock }.not_to raise_exception
      end

      it "should pass the unlock exception to handler" do
        unlock_exception = StandardError.new('This exception should be surpressed.')
        rescued_surpressed_exception = nil
        CgSemaphore::Semaphore.rescue_surpressed_exception { |e, s| rescued_surpressed_exception = e }

        @wrappedSemaphore.stub(:unlock) { raise unlock_exception }
        @semaphore.unlock

        expect(rescued_surpressed_exception).to eq unlock_exception
      end
    end
  end
end
