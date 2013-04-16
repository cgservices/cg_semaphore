require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CgSemaphore do
  before do

  end

  after do

  end

  describe "COMMAND: lock" do
    before do
      @semaphore = new CgSemaphore::Semaphore()
    end

    after do

    end

    it "should return blaat" do
      @semaphore.lock("testlock").should eq("blaat")
    end
  end
end