require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require 'cg_semaphore/officer'

CgSemaphore::OwnedSemaphore.owned_semaphore_class = ::CgSemaphore::Officer::OwnedSemaphore

describe CgSemaphore::Mutex do
  subject { CgSemaphore::Mutex.new "testlock" }

  describe "#with_lock" do
    it "should yield the block" do
      result = []
      subject.with_lock { result << 1 }
      result.should eq [1]
    end
  end
end
