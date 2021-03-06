Gem::Specification.new do |gem|
  gem.authors       = ['Luis Doubrava', 'Rob van Aarle']
  gem.email         = ['luis@cg.nl', 'rob@cg.nl']
  gem.description   = 'CG Semaphore is an abstract layer for semaphores and mutexes in Ruby'
  gem.summary       = 'CG Semaphore is an abstract layer for semaphores and mutexes in Ruby'
  gem.homepage      = 'https://github.com/cgservices/cg_semaphore'

  gem.files         = `git ls-files`.split($\)
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = 'cg_semaphore'
  gem.require_paths = ['lib']
  gem.version       = "0.10.2"

  gem.add_dependency("officer", ['>= 0.11.0'])
  gem.add_development_dependency('rake', ['>= 0'])
  gem.add_development_dependency('rspec', ['>= 0'])
  gem.add_development_dependency('pry', ['>= 0'])
end
