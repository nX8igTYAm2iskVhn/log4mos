require 'rubygems/package_task'

ROOT_DIR = File.dirname(__FILE__)
gemspec = Gem::Specification.load("#{Dir.glob(ROOT_DIR + '/*.gemspec')[0]}")
Gem::PackageTask.new gemspec do end

require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)
task :default => :spec


task :simplecov do
  ENV['RUN_SIMPLECOV'] = 'true'
  Rake::Task[:spec].execute
end
