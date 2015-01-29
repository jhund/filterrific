* using the "sorted_by" magic method will add entries to select_options automatically
    filterrific(
      default_filter_params: { sorted_by: 'name_asc' },
      available_filters: [
        :with_country,
        ...
      ],
      search_query: {
        match_terms: :any, # [:all]
        auto_wildcard: :suffix, # [:prefix, :both, :none]
        columns: [:first_name, :email, :last_name],
        case_sensitive: false, # [true]
      },
      sorted_by: {
        name_asc: 'Name (A-Z)',
        name_desc: 'Name (Z-A)',
      },
    )

    filterrific(
      default_filter_params: { sorted_by: 'name_asc' },
      custom_scopes: [
        :with_country,
        ...
      ],
      lookup_filters: [ # column_value_filters:, value_filters:
        :with_country_id,
        :with_state,
      ]
      search_query: {
        match_terms: :any, # [:all]
        auto_wildcard: :suffix, # [:prefix, :both, :none]
        columns: [:first_name, :email, :last_name],
        case_sensitive: false, # [true]
      },
      sorted_by: {
        name_asc: 'Name (A-Z)',
        name_desc: 'Name (Z-A)',
      },
    )

### 2.0.2

* Fixed bugs in ActionControllerExtension
* Improved test coverage



### 2.0.1

* Fixed regression with Rails 3.2 (doesn't support `#deep_stringify_keys`)



# 2.0.0

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



### 1.4.3

* Handle case where Filterrific filter params are empty.



### 1.4.2

* Updated initialization of ActiveRecord and ActionView extensions again



### 1.4.1

* Updated initialization of ActiveRecord and ActionView extensions



### 1.4.0

* Better support for new versions of Rails (integration tests are done in filterrific_demo)
* Fixed asset pipeline for filterrific-spinner.gif.
* Isolate_namespace
* Update Gem dependencies
* Switch from Rspec to Minitest
* Require Rails 3.1 or greater



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
