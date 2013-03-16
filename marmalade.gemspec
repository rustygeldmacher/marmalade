# -*- encoding: utf-8 -*-
require File.expand_path('../lib/marmalade/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Rusty Geldmacher"]
  gem.email         = ["russell.geldmacher@gmail.com"]
  gem.description   = %q{Marmalade gives you ready-to-go parsing and other helpers for Google Code Jam puzzles}
  gem.summary       = %q{Helper for Google Code Jam puzzles}
  gem.homepage      = "http://www.github.com/rustygeldmacher/marmalade"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "marmalade"
  gem.require_paths = ["lib"]
  gem.version       = Marmalade::VERSION

  gem.add_dependency 'trollop', '~>1.16.2'
  gem.add_dependency 'parallel', '0.6.2'

  gem.add_development_dependency 'rspec', '~>2.9.0'
  gem.add_development_dependency 'mocha', '~>0.10.5'
end
