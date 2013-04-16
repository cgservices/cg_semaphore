require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CgSemaphore do
  before do

  end

  after do

  end

  describe "COMMAND: lock" do
    before do
      @semaphore = CgSemaphore::Semaphore.new 9
    end

    after do

    end

    it "should return blaat" do
      #@semaphore.lock("testlock").should eq("blaat")
      @semaphore.with_lock("testlock") do
        puts "body of code within lock"
        raise "Argh"
      end
    end
  end
end