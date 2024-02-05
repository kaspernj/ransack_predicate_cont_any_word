$LOAD_PATH.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "ransack_predicate_cont_any_word/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name = "ransack_predicate_cont_any_word"
  s.version = RansackPredicateContAnyWord::VERSION
  s.authors = ["kaspernj"]
  s.email = ["k@spernj.org"]
  s.homepage = "https://www.github.com/kaspernj/ransack_predicate_cont_any_word"
  s.summary = "'cont_any_word' predicate for Ransack."
  s.description = "'cont_any_word' predicate for Ransack."
  s.license = "MIT"
  s.required_ruby_version = ">= 2.7"
  s.metadata["rubygems_mfa_required"] = "true"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
end
