require_relative 'lib/miner_device/version'

Gem::Specification.new do |spec|
  spec.name          = 'miner_device'
  spec.version       = MinerDevice::VERSION
  spec.authors       = ['Maksim Khodorev']
  spec.email         = ['mkhodorev@gmail.com']

  spec.summary       = 'MinerDevice'
  spec.description   = 'Sample MinerDevice'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.4.0')

  spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
end
