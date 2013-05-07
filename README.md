# CG Semaphore
A Gem with a small semaphore and mutex abstraction layer. It currently only has an implementation for Cg Officer.

## Installation
### Specify dependency in your Gemfile
gem 'cg\_semaphore', :git => "https://github.com/cgservices/cg_semaphore.git"
    
### Usage
CgSemaphore must be configured with an semaphore implementation:

    # set class to use for semaphores
    require 'cg_semaphore'
    require 'cg_semaphore/officer'
    CgSemaphore::OwnedSemaphore.owned_semaphore_class = ::CgSemaphore::Officer::OwnedSemaphore

It's possible to surpress exceptions raised by the implementation. If an exception was surpressed, CgSemaphore acts like
the lock was a success. This way the application can continue as normal, but the code is not synchronized. To be
notified about this surpressed exception, a callback can be defined:

    # surpressed exceptions handling: these should be logged as warnings
    CgSemaphore::Semaphore.rescue_surpressed_exception { |e, semaphore| puts "Caught exception #{e}" }

Basic usage of the semaphore:

    semaphore = CgSemaphore::Semaphore.new "testlock", 3

    semaphore.with_lock do
      # execture dangerous code
    end
    # with_lock ensures the unlock, even if an exception was raised

    # alternatively
    semaphore.lock
      # execute dangerous code
    semaphore.unlock

### Cg Officer
To use Cg Officer for semaphores, a Cg Officer client needs to be configured that will be used for each semaphore:

    CgSemaphore::Officer.client = Officer::Client.new