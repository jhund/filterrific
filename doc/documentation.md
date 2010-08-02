# Filterrific Documentation

## Word list

* Filterrific - the gem
* Filterrific::Param - individual element of a *FilterrificParamSet*.
  Defines how the AR list should be filtered. Managed via instance of *FilterrificParamSet* class.
* Filterrific::ScopeNames - List of *Scope* names that are available to *Filterrific*.
* Filterrific::ParamSet - Container for *FilterrificParams*
* Filterrific::Form - a HTML form used to define *FilterrificParams*
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

  