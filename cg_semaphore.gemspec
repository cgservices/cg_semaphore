Gem::Specification.new do |gem|
  gem.authors       = ['Luis Doubrava', 'Rob van Aarle']
  gem.email         = ['luis@cg.nl', 'rob@cg.nl']
  gem.description   = 'CG Semaphore is an abstract layer for semaphores and mutexes in Ruby'
  gem.summary       = 'CG Semaphore is an abstract layer for semaphores and mutexes in Ruby'
  gem.homepage      = ''

  gem.files         = `git ls-files`.split($\)
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = 'cg_semaphore'
  gem.require_paths = ['lib']
  gem.version       = "0.9.0"

  gem.add_dependency("officer", ['>= 0'])
  gem.add_development_dependency('rake', ['>= 0'])
  gem.add_development_dependency('rspec', ['>= 0'])
end