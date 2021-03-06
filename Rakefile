require 'rubygems'
require 'bundler/setup'

require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-strings/tasks'

begin
  require 'puppet_blacksmith/rake_tasks'
rescue LoadError
  # Nothing to see here
end

begin
  require 'rubocop/rake_task'
rescue LoadError # rubocop:disable Lint/HandleExceptions
end

begin
  require 'puppet-strings/rake_tasks'
rescue LoadError # rubocop:disable Lint/HandleExceptions
end

PuppetLint.configuration.relative = true
PuppetLint.configuration.disable_80chars
PuppetLint.configuration.log_format = "%{path}:%{linenumber}:%{check}:%{KIND}:%{message}"
PuppetLint.configuration.fail_on_warnings = true

# Forsake support for Puppet 2.6.2 for the benefit of cleaner code.
# http://puppet-lint.com/checks/class_parameter_defaults/
PuppetLint.configuration.disable_class_parameter_defaults
# http://puppet-lint.com/checks/class_inherits_from_params_class/
PuppetLint.configuration.disable_class_inherits_from_params_class
# To fix unquoted cases in spec/fixtures/modules/apt/manifests/key.pp
PuppetLint.configuration.disable_unquoted_string_in_case

exclude_paths = [
    "pkg/**/*",
    "vendor/**/*",
    "spec/**/*",
]
PuppetLint.configuration.ignore_paths = exclude_paths
PuppetSyntax.exclude_paths = exclude_paths

# begin
#   require 'parallel_tests/cli'
#   desc 'Run spec tests in parallel'
#   task :parallel_spec do
#     Rake::Task[:spec_prep].invoke
#     ParallelTests::CLI.new.run('--type test -o "--format=progress" -t rspec spec/classes spec/defines'.split)
#     Rake::Task[:spec_clean].invoke
#   end
#   desc 'Run syntax, lint, spec, and metadata tests in parallel'
#   task :parallel_test => [
#       :syntax,
#       :lint,
#       :parallel_spec,
#       :metadata,
#   ]
#   rescue LoadError # rubocop:disable Lint/HandleExceptions
# end


desc 'Run Acceptance test'
task :acceptance do
  sh 'rspec spec/acceptance'
end

desc 'Run syntax, lint, spec and metadata tests'
task :test => [
    :syntax,
    :lint,
    :spec,
    :metadata_lint,
]

desc 'Validate manifests, templates, and ruby files'
task :deploy do
  Dir['spec/**/*.rb','lib/**/*.rb'].each do |ruby_file|
    sh "ruby -c #{ruby_file}" unless ruby_file =~ /spec\/fixtures/
  end
  Rake::Task[:release_checks].invoke
  Rake::Task['module:release'].invoke
end
