Gem::Specification.new do |gem|
  gem.authors       = ['Luis Doubrava']
  gem.email         = ['luis@cg.nl']
  gem.description   = 'CG Semaphore is an interface to use Semaphores in Ruby'
  gem.summary       = 'CG Semaphore is an interface to use Semaphores in Ruby'
  gem.homepage      = ''

  gem.files         = `git ls-files`.split($\)
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = 'cg_ability'
  gem.require_paths = ['lib']
  gem.version       = "0.0.1pre"

  gem.add_dependency("officer", ['>= 0'])
  gem.add_development_dependency('rake', ['>= 0'])
  gem.add_development_dependency('rspec', ['>= 0'])
  gem.add_development_dependency('yard')
end