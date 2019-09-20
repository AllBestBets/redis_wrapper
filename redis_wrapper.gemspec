# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'redis_wrapper/version'

Gem::Specification.new do |spec|
  spec.name          = "redis_wrapper"
  spec.version       = RedisWrapper::VERSION
  spec.authors       = ["Andrey Blinov"]
  spec.email         = ["andrey.blinoff@gmail.com"]

  spec.summary       = ""
  spec.description   = ""
  spec.homepage      = "http://www.iruby.com.cn"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_runtime_dependency "rediscluster"
end
