lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'ssim/version'

Gem::Specification.new do |spec|
  spec.name          = 'ssim'
  spec.version       = SSIM::VERSION
  spec.authors       = ['Kolesnikov Danil']
  spec.email         = ['kolesnikovde@gmail.com']
  spec.summary       = 'SSIM parser.'
  spec.description   = 'SSIM parser.'
  spec.homepage      = 'https://github.com/kolesnikovde/ssim'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^spec/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.9'
  spec.add_development_dependency 'rake',    '~> 10.0'
  spec.add_development_dependency 'rspec',   '~> 3'
end
