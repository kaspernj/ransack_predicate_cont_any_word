require "English"
require "pty"
require_relative "../ransack_predicate_cont_any_word/version"

task :environment unless Rake::Task.task_defined?(:environment)

module ReleaseTasks
module_function

  VERSION_FILE = File.expand_path("../ransack_predicate_cont_any_word/version.rb", __dir__)
  GEMSPEC_FILE = "ransack_predicate_cont_any_word.gemspec".freeze

  def run_patch_release
    current_version = Gem::Version.new(RansackPredicateContAnyWord::VERSION)
    new_version = next_patch_version(current_version)

    bump_version!(current_version, new_version)
    build_gem!
    push_gem!(new_version)
  end

  def next_patch_version(current_version)
    major, minor, patch = current_version.segments.fill(0, current_version.segments.length...3)
    [major, minor, patch + 1].join(".")
  end

  def bump_version!(current_version, new_version)
    version_source = File.read(VERSION_FILE)
    updated_version_source = version_source.sub(
      /VERSION = "[^"]+"\.freeze/,
      "VERSION = \"#{new_version}\".freeze"
    )
    abort "Could not update version in #{VERSION_FILE}" if version_source == updated_version_source

    File.write(VERSION_FILE, updated_version_source)
    puts "Bumped version: #{current_version} -> #{new_version}"
  end

  def build_gem!
    abort "gem build failed" unless system("gem", "build", GEMSPEC_FILE)
  end

  def push_gem!(new_version)
    gem_file = "ransack_predicate_cont_any_word-#{new_version}.gem"
    abort "Built gem file not found: #{gem_file}" unless File.exist?(gem_file)

    status = push_gem_via_pty(gem_file)
    abort "gem push failed" unless status&.zero?
  end

  def push_gem_via_pty(gem_file)
    status = nil
    PTY.spawn("gem", "push", gem_file) do |stdout, stdin, pid|
      output_thread = Thread.new { stream_output(stdout) }
      input_thread = Thread.new { stream_input(stdin) }

      Process.wait(pid)
      status = $CHILD_STATUS.exitstatus
      output_thread.join
      input_thread.kill
    end
    status
  end

  def stream_output(stdout)
    loop do
      print stdout.readpartial(1024)
    end
  rescue EOFError, Errno::EIO => e
    warn e.message if ENV["DEBUG_RELEASE_PATCH"]
  end

  def stream_input(stdin)
    loop do
      stdin.write($stdin.readpartial(1024))
    end
  rescue EOFError, Errno::EIO => e
    warn e.message if ENV["DEBUG_RELEASE_PATCH"]
    stdin.close unless stdin.closed?
  end
end

namespace :release do
  desc "Bump patch version, build gem, and push gem to RubyGems"
  task patch: :environment do
    ReleaseTasks.run_patch_release
  end
end
