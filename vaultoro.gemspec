require './lib/vaultoro/version'

Gem::Specification.new do |spec|
  spec.name                  = 'vaultoro'
  spec.version               = Vaultoro::VERSION::STRING
  spec.summary               = Vaultoro::VERSION::SUMMARY
  spec.description           = Vaultoro::VERSION::DESCRIPTION
  spec.platform              = Gem::Platform::RUBY
  spec.required_ruby_version = '>= 2.2'

  spec.authors               = ['Jurgen Jocubeit']
  spec.email                 = ['support@exavest.com']
  spec.homepage              = 'https://github.com/exavest/vaultoro'
  spec.license               = 'MIT'
  spec.metadata              = {'copyright' => 'Copyright 2018 Jurgen Jocubeit'}

  spec.require_paths         = ['lib']
  spec.files                 = Dir.glob('{lib}/**/*') + %w(README.md CHANGELOG.md LICENSE.md)

  spec.add_runtime_dependency 'virtus', '~> 1.0.3'
  spec.add_development_dependency 'rake'
end
