# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

Filterrific major versions match the Ruby on Rails major versions they work with.

## [5.2.3] - Mar. 18, 2022

* Added support for Rails 7

## [5.2.2] - Jul. 11, 2021

* Fixed Ruby 2.7 deprecated warning when trying to regex match an Integer.
* Added ability to pass custom url parameter instead of default :filterrific.
* Added basic Aria attrs to spinner for accessibility.
* Improved concurrent ajax requests: Abort prior request when new ones are triggered.

## [5.2.1] - Aug. 5, 2019

* Fixed issue where uncommitted code was pushed to rubygems and broke array filters.

## [5.2.0] - Jul. 21, 2019

* Make Filterrific master branch compatible with Rails 5 and 6.
* Trigger synthetic JS events before and after form submission ajax requests.

## [5.1.0] - Aug. 3, 2018

* Breaking change: all Filterrific params are sanitized by default to prevent XSS attacks. You can disable sanitization (you really shouldn't!) by setting the :sanitize_params option to false when calling #initialize_filterrific in the controller.

## [5.0.1] - Jan. 2, 2018

* Changed all instances of #deep_stringify_keys back to #stringify_keys. This was changed in 5.0.0, but it shouldn't have been changed.

## [5.0.0] - Dec. 31, 2017

* We're switching to a new versioning strategy for Filterrific: Filterrific major releases (the first number in the version) will be matched with the supported major version of Rails. Minor and path versions may diverge from Rails. That means for any version of Rails 5.x you will use the most current version of Filterrific 5.x.

## [4.0.0] - Dec. 31, 2017

* This is the first release of Filterrific specifically geared towards Rails 4.x. No functional changes, just new versioning system and removal of unused code.

## [3.0.0] - Dec. 31, 2017

* This is the first release of Filterrific specifically geared towards Rails 3.x. No functional changes, just new versioning system and removal of unused code.

## [2.1.2] - Nov. 11, 2016

* Removed older way of initializing assets, relying on config/initializers/assets.rb for all versions of Rails.

## [2.1.1] - Nov. 11, 2016

* Reverted asset initialization back to working state for versions prior to Rails5.

## [2.1.0] - Nov. 6, 2016

* Updated filterrific for Rails 5 compatibility:
    * Turbolinks compatibility (thanks @olegantonyan)
    * Updated to Ruby 2.2.2 in CI test matrix
    * Added Ruby 2.3.1 to CI test matrix (thanks @rodrigoargumedo)
    * Fixed #stringify_keys deprecation warning (thanks @olegantonyan)
* When generating sorting headers, allow usage of HTML (e.g., for icons) using #safe_join (thanks @ScottKolo)
* Improved param casting to Int: hyphens and zeros (thanks @grit96)


## [2.0.5] - May 4, 2015

* Feature: Allow disabling of session persistence by passing `false` as
  `:persistence_id` option.
* Fix: Direction indicators on sortable headers are now correct.
* Fix: Make JS event observers work with TurboLinks.
* Fix: Make reset_filterrific_url available in controller.



## [2.0.4] - Mar. 10, 2015

* Objectify nested params so that they render correctly on the form when
  restored from session or URL params.
* Don't convert strings that almost look like integers to integers. Example:
  `"0123"` as part of a phone number should not be converted to `123`.



## [2.0.3] - Jan. 30, 2015

* Cleaned up obsolete option names



## [2.0.2] - Jan. 28, 2015

* Fixed bugs in ActionControllerExtension
* Improved test coverage



## [2.0.1] - Jan. 28, 2015

* Fixed regression with Rails 3.2 (doesn't support `#deep_stringify_keys`)



## [2.0.0] - Jan. 28, 2015

API changes:

* Filterrific model API option names have changed.
* Better initialization of Filterrific via `initialize_filterrific` method:
    * It resets the filter params, so the `reset_filterrific` action is not required any more.
    * It persists filter params in session.
* Simplified `@filterrific.find` method to load collection from DB.
  Replaces `Student.filterrific_find(@filterrific)`
* The `form_for_filterrific` form builder doesn't override the standard
  `form_for` method any more.
* Dropped support for Ruby 1.8.7 (because of 1.9 Hash syntax)
* Dropped support for Rails <= 3.0.0 (because of ActiveRecord
  bug fixes in 3.1, and use of asset pipeline)



## [1.4.3] - Jan. 12, 2015

* Handle case where Filterrific filter params are empty.



## [1.4.2] - Oct. 18, 2014

* Updated initialization of ActiveRecord and ActionView extensions again



## [1.4.1] - Oct. 15, 2014

* Updated initialization of ActiveRecord and ActionView extensions



## [1.4.0] - Oct. 13, 2014

* Better support for new versions of Rails (integration tests are done in filterrific_demo)
* Fixed asset pipeline for filterrific-spinner.gif.
* Isolate_namespace
* Update Gem dependencies
* Switch from Rspec to Minitest
* Require Rails 3.1 or greater



## [1.3.1] - Jun. 18, 2014

* Changed ParamSet#select_options so that a complete hash can be assigned



## [1.3.0] - Jun. 3, 2014

* Added ParamSet#select_options (thanks @pnomolos).
* Added ParamSet#signature to quickly test two param_sets for equality.
* Bugfix: When using with Rails 4.0: Fixed ‘wrong number of arguments 0 for 1’ exception (thanks @sebboh).
* Bugfix: jQuery bug in `form_for` helper (thanks @sebboh).
* Bugfix: removed duplicate dependency in .gemspec.

* Updated documentation.
* Updated Gemfile source
* Refactored ParamSet initialization.
* Refactored ActiveRecordExtension initialization.



## [1.2.0] - May 16, 2013

* Added simple wrapper for Filterrific::ParamSet.new so that it can be
  instantiated with Filterrific.new instead of Filterrific::ParamSet.new.
* Overrode ActionView's form_for to add filterrific magic when applied to a
  Filterrific object.
* Fixed bug with javascript periodic observer, changed css selector class to
  avoid conflicts.
* Moved observe_form_field jquery plugin into filterrific namespace to avoid
  conflicts.



## [1.1.0] - May 8, 2013

* Major refactor.
* Added specs.
* Tied in Rails asset pipeline.
* Added gh-pages branch for documentation.



## [1.0.1] - Nov. 9, 2011

* Bug fix: Replaced stringify_keys with map.to_s (filter_names is an Array, not a Hash!).



## [1.0.0] - Nov. 9, 2011

* Support for Rails 3.1.
* New model api.



## [0.1.0] - Aug. 1, 2010

* Replicate functionality of Rails 2.3 version.



## [0.0.1] - Jul. 30, 2010

* Initial setup.
