# CG Semaphore
A Gem for engine authorization. This gem extends the functionality of CanCan autorization gem. For a full set of options see CanCan documentation.

## Installation
### Specify dependency in your Gemfile
gem 'cg_semaphore', :git => "https://github.com/cgservices/cg_semaphore.git"
    
### Usage
CG Ability looks in Engine.root/config for the yaml file defined in Engine.config.roles_yml. If this file is not found then Error will be raised.

    # test.rb
    semaphore.lock
    # execute dangerous code
    semaphore.unlock

    # or
    semaphore.with_lock do
      # execture dangerous code
    end