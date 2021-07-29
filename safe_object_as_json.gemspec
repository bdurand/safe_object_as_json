Gem::Specification.new do |spec|
  spec.name = "safe_object_as_json"
  spec.version = File.read(File.expand_path("../VERSION", __FILE__)).strip
  spec.authors = ["Brian Durand"]
  spec.email = ["bbdurand@gmail.com"]

  spec.summary = "Drop in replacement for the Object#as_json implementation in ActiveSupport, but with logic to handle circular references between objects to avoid infinite recursion."
  spec.homepage = "https://github.com/bdurand/safe_object_as_json"
  spec.license = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  ignore_files = %w[
    .
    Appraisals
    Gemfile
    Gemfile.lock
    Rakefile
    bin/
    gemfiles/
    spec/
    web_ui.png
  ]
  spec.files = Dir.chdir(File.expand_path("..", __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| ignore_files.any? { |path| f.start_with?(path) } }
  end

  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport"

  spec.add_development_dependency "bundler"

  spec.required_ruby_version = ">= 2.5"
end