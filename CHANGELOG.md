### 1.3.1

* Changed ParamSet#select_options so that a complete hash can be assigned



## 1.3.0

* Added ParamSet#select_options (thanks @pnomolos).
* Added ParamSet#signature to quickly test two param_sets for equality.
* Bugfix: When using with Rails 4.0: Fixed ‘wrong number of arguments 0 for 1’ exception (thanks @sebboh).
* Bugfix: jQuery bug in `form_for` helper (thanks @sebboh).
* Bugfix: removed duplicate dependency in .gemspec.

* Updated documentation.
* Updated Gemfile source
* Refactored ParamSet initialization.
* Refactored ActiveRecordExtension initialization.



## 1.2.0

* Added simple wrapper for Filterrific::ParamSet.new so that it can be
  instantiated with Filterrific.new instead of Filterrific::ParamSet.new.
* Overrode ActionView's form_for to add filterrific magic when applied to a
  Filterrific object.
* Fixed bug with javascript periodic observer, changed css selector class to
  avoid conflicts.
* Moved observe_form_field jquery plugin into filterrific namespace to avoid
  conflicts.




## 1.1.0

* Major refactor.
* Added specs.
* Tied in Rails asset pipeline.
* Added gh-pages branch for documentation.


### 1.0.1

* Bug fix: Replaced stringify_keys with map.to_s (filter_names is an Array, not a Hash!).




# 1.0.0

* Support for Rails 3.1.
* New model api.



## 0.1.0, released 2010-08-01

* Replicate functionality of Rails 2.3 version.


### 0.0.1, released 2010-07-30

* Initial setup.
