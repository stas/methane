# -*- encoding: utf-8 -*-
require File.expand_path('../lib/methane/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Stas SUȘCOV"]
  gem.email         = ["stas@nerd.ro"]
  gem.description   = %q{Campfire desktop client}
  gem.summary       = %q{Because we need a decent open source Campfire client.}
  gem.homepage      = "https://github.com/stas/methane"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "methane"
  gem.require_paths = ["lib"]
  gem.version       = Methane::VERSION

  gem.add_dependency('slop')
  gem.add_development_dependency('rake')
end
