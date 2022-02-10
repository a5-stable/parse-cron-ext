require_relative 'lib/parse-cron-ext/version'

Gem::Specification.new do |spec|
  spec.name          = "parse-cron-ext"
  spec.version       = Parse::Cron::Ext::VERSION
  spec.authors       = ["a5-stable"]
  spec.email         = ["sh07e1916@gmail.com"]

  spec.summary       = %q{parse-cron-ext is a extension (monkey-patch) for parse-cron 0.1.4, which is the latest version.}
  spec.description   = %q{enable to specify "end of the month", "end of the month in March", "Third Monday", and so on... in cron by extending of parse-cron.}
  spec.homepage      = "https://github.com/a5-stable/parse-cron-ext"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["homepage_uri"] = "https://github.com/a5-stable/parse-cron-ext"
  spec.metadata["source_code_uri"] = "https://github.com/a5-stable/parse-cron-ext"
  spec.metadata["changelog_uri"] = "https://github.com/a5-stable/parse-cron-ext"
  spec.add_dependency 'parse-cron', '>= 0.1.4'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
