#!/usr/bin/env rake
begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end
begin
  require 'yard'
  YARD::Rake::YardocTask.new
rescue LoadError
  task :yardoc do
    abort "YARD is not available. In order to run yardoc, you must: sudo gem install yard"
  end
end

# TODO: figure out how to do this for Yard
# YardocTask.new(:yardoc) do |yardoc|
#   yardoc.rdoc_dir = 'rdoc'
#   rdoc.title    = 'DummyGem'
#   rdoc.options << '--line-numbers'
#   rdoc.rdoc_files.include('README.rdoc')
#   rdoc.rdoc_files.include('lib/**/*.rb')
# end

Bundler::GemHelper.install_tasks

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new('spec')
# If you want to make this the default task
task :default => :spec
