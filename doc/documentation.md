# Filterrific Documentation

## Word list

* Filterrific - the gem
* Filterrific parameters - a set of parameters that define how the AR list should be filtered. Managed
  via instance of FilterrificParamSet class
* Filterrific form - a HTML form used to define *Filter parameters*
* Scope - An ActiveRecord scope (formerly known as named_scope)

## Brain dump

* Scenarios
  * Saved search (persist FilterrificParamSet in DB)
  * Will paginate integration
  * Session persistence
* Defining Scopes
  * Belongs_to
  * Has_many
  * Sorting
  * Full text search (Postgres, Like, regex, Sphinx?)
* Filterrific form inputs
  * checkboxes
  * multi selects

## Requirements

* Rails3

  