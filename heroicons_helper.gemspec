# frozen_string_literal: true

require_relative "lib/heroicons_helper/version"

Gem::Specification.new do |spec|
  spec.name = "heroicons_helper"
  spec.version = HeroiconsHelper::VERSION
  spec.authors = ["Garen J. Torikian"]
  spec.email = ["gjtorikian@users.noreply.github.com"]

  spec.summary       = "Heroicons port for Ruby"
  spec.description   = "A package that distributes Heroicons as a gem, for easy inclusion in Ruby projects."
  spec.homepage      = "https://github.com/gjtorikian/heroicons_helper"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.7.0", "< 4.0.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata = {
    "funding_uri" => "https://github.com/sponsors/gjtorikian/",
    "rubygems_mfa_required" => "true",
  }

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    %x(git ls-files -z).split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency("activesupport", ">= 6")

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
