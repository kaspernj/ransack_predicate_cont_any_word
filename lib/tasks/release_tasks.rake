require "pty"
require_relative "../ransack_predicate_cont_any_word/version"

namespace :release do
  desc "Bump patch version, build gem, and push gem to RubyGems"
  task :patch do
    version_file = File.expand_path("../ransack_predicate_cont_any_word/version.rb", __dir__)
    current_version = Gem::Version.new(RansackPredicateContAnyWord::VERSION)
    major, minor, patch = current_version.segments.fill(0, current_version.segments.length...3)
    new_version = [major, minor, patch + 1].join(".")

    version_source = File.read(version_file)
    updated_version_source = version_source.sub(
      /VERSION = "[^"]+"\.freeze/,
      "VERSION = \"#{new_version}\".freeze"
    )
    abort "Could not update version in #{version_file}" if version_source == updated_version_source

    File.write(version_file, updated_version_source)
    puts "Bumped version: #{current_version} -> #{new_version}"

    abort "gem build failed" unless system("gem", "build", "ransack_predicate_cont_any_word.gemspec")

    gem_file = "ransack_predicate_cont_any_word-#{new_version}.gem"
    abort "Built gem file not found: #{gem_file}" unless File.exist?(gem_file)

    status = nil
    PTY.spawn("gem", "push", gem_file) do |stdout, _stdin, pid|
      begin
        loop do
          print stdout.readpartial(1024)
        end
      rescue EOFError, Errno::EIO
      ensure
        Process.wait(pid)
        status = $?.exitstatus
      end
    end

    abort "gem push failed" unless status == 0
  end
end
