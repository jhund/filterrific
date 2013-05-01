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
  * will_paginate integration
  * Session persistence
  * Interface for JS client side app to get collections of data via JSON REST
  * integrate with PG fulltext search (pg_search)
* Filterrific form inputs
  * checkboxes
  * multi selects

## Requirements

* Rails3 (or 3.1?)
