begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

Bundler::GemHelper.install_tasks

require 'rake/testtask'
Rake::TestTask.new do |test|
  test.libs << 'spec'
  test.pattern = 'spec/**/*_spec.rb'
  test.verbose = true
end

require 'wwtd/tasks'
task default: 'wwtd:local'
