require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "filterrific"
    gem.summary = %Q{The Rails User Interface solution for filtering your ActiveRecord lists.}
    gem.description = %Q{
      The Rails User Interface solution for filtering your ActiveRecord lists:

      * Built from the ground up for Rails3
      * Build filter forms with ease
      * Filter ActiveRecord lists using AR scopes
      * Shuttle filter parameters from view to controller to model in a RESTful way
      * Auto-generate scopes for AR associations (Planned)
      * Form builder for filter UI forms (Planned)
    }
    gem.email = "jhund@clearcove.ca"
    gem.homepage = "http://github.com/jhund/filterrific"
    gem.authors = ["Jo Hund"]
    gem.add_development_dependency "thoughtbot-shoulda", ">= 0"
    gem.add_development_dependency "yard", ">= 0"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/test_*.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :test => :check_dependencies

task :default => :test

begin
  require 'yard'
  YARD::Rake::YardocTask.new
rescue LoadError
  task :yardoc do
    abort "YARD is not available. In order to run yardoc, you must: sudo gem install yard"
  end
end
