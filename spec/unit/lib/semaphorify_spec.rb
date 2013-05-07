require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require 'cg_semaphore/semaphore'

describe CgSemaphore::Semaphore do
  before do
    class SemaphoriedDummyClass
      include CgSemaphore::Semaphorify
    end

    @semaphore = SemaphoriedDummyClass.new "testlock", 3
    @semaphore.stub(:unlock) { true }
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

  describe "#with_lock" do
    it "should lock" do
      @semaphore.stub(:lock) { false }
      @semaphore.should_receive(:lock).once
      @semaphore.with_lock {  }
    end

    context "when locking succeeds" do
      before do
        @semaphore.stub(:lock) { true }
      end

      it "should execture the block" do
        block_executed = false
        @semaphore.with_lock { block_executed = true }
        block_executed.should be_true
      end

      it "should unlock" do
        @semaphore.should_receive(:unlock).once
        @semaphore.with_lock { }
      end

      context "and the block raises an exception" do
        it "should raise the block's exception" do
          expect{@semaphore.with_lock { raise StandardError.new("block exception") }}.to raise_exception(StandardError, "block exception")
        end

        context "and the unlock raises an exception" do
          it "should raise the block's exception" do
            @semaphore.stub(:unlock) { raise "unlock exception" }
            expect{@semaphore.with_lock { raise StandardError.new("block exception") }}.to raise_exception(StandardError, "block exception")
          end
        end
      end
    end

    context "when locking raises an exception" do
      before do
        @semaphore.stub(:lock) { raise "lock exception" }
      end

      it "should not execute the block" do
        block_executed = false

        begin
          @semaphore.with_lock { block_executed = true }
        rescue
        end
        block_executed.should be_false
      end

      it "should not unlock" do
        @semaphore.should_not_receive(:unlock)

        begin
          @semaphore.with_lock { }
        rescue
        end
      end
    end
  end

  describe "#with_try_lock" do
    it "should try_lock" do
      @semaphore.stub(:try_lock) { false }
      @semaphore.should_receive(:try_lock).once
      @semaphore.with_try_lock {  }
    end

    context "when locking succeeds" do
      before do
        @semaphore.stub(:try_lock) { true }
      end

      it "should execture the block" do
        block_executed = false
        @semaphore.with_try_lock { block_executed = true }
        block_executed.should be_true
      end

      it "should unlock" do
        @semaphore.should_receive(:unlock).once
        @semaphore.with_try_lock { }
      end

      context "and the block raises an exception" do
        it "should raise the block's exception" do
          expect{@semaphore.with_try_lock { raise StandardError.new("block exception") }}.to raise_exception(StandardError, "block exception")
        end

        context "and the unlock raises an exception" do
          it "should raise the block's exception" do
            @semaphore.stub(:unlock) { raise "unlock exception" }
            expect{@semaphore.with_try_lock { raise StandardError.new("block exception") }}.to raise_exception(StandardError, "block exception")
          end
        end
      end
    end


    shared_context "when locking does not succeed" do
      it "should not execute the block" do
        block_executed = false

        begin
          @semaphore.with_try_lock { block_executed = true }
        rescue
        end
        block_executed.should be_false
      end

      it "should not unlock" do
        @semaphore.should_not_receive(:unlock)

        begin
          @semaphore.with_try_lock { }
        rescue
        end
      end
    end

    context "when locking fails" do
      before do
        @semaphore.stub(:try_lock) { false }
      end

      include_context "when locking does not succeed"
    end

    context "when locking raises an exception" do
      before do
        @semaphore.stub(:try_lock) { raise "lock exception" }
      end

      include_context "when locking does not succeed"
    end
  end
end