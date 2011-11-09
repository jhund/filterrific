filterrific do
  filter :with_project
  sort ...
  search ...
  config :prefix, 'lala'
  config.debug = true
end

# xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

# TODO: find out why in PTS publications filter, some hidden fields are set to nil and others to "0".
# If I change it, filter stops working


filterrific do

  # Creates custom scope "filterrific_person". Finds all records that have one of the given values
  # in :person_id column
  # Accepts: Person.new, 17, [Person.new, Person.new], [12, 13, 14], [12, 13, Person.new]
  # scope :filterrific_person, lambda { |persons|
  #   sanitize: convert all entries to an id (integer), convert to array, do nothing if persons.empty?
  #   foreign_key: inspect association to get foreign key
  #   where(:person_id => persons)
  # }
  filter :belongs_to => :person

  # Creates custom scope "filterrific_is_active". Finds all records that have one of the given
  # values for :is_active column
  # Accepts: "true", true, [true, false], [true, 13, false]
  # scope :filterrific_is_active, lambda { |values|
  #   sanitize: convert all entries to column type, convert to array, do nothing if values.empty?
  #   where(:is_active => values)
  # }
  filter :column => :is_active, :default => true

  # Creates scopes for date/datetime columns.
  # Possible conditions: :after, :before, :on_or_after, :on_or_before
  # scope :filterrific_created_at_on_or_after, lambda { |datetime|
  #   datetime = sanitize datetime
  #   return nil  if datetime.blank
  #   table_name = get tablename from class
  #   where(['tablename.created_at >= ?', datetime])
  # }
  filter :column => :created_at, :condition => :on_or_after, :default => Proc.new { 2.years.ago.beginning_of_year }
  filter :column => :last_login_on, :condition => :before
  
  # Creates custom scope "filterrific_some_complex_scope". Uses scope :some_complex_scope
  # scope :filterrific_some_complex_scope, lambda { |*args|
  #   some_complex_scope(args)
  # }
  filter :scope => :some_complex_scope
  
  # Available options for filter:
  #
  # Options for filter type:
  # :belongs_to: to filter on a belongs_to association
  # :column: to filter on a column
  # :scope: to delegate filtering to a scope that is already defined on the class
  #
  # General options:
  # :default: to set the default, can be static value or Proc.new
  # :name: to change the name for a given filter. The name will still be prefixed with filterrific_prefix
  #
  # Possible conditions for :column filters:
  # * in: contained in set, IN (This is the default condition)
  # * comparisons: :after, :before, :on_or_after, :on_or_before, >, <, >=, <=
  # * equals: exactly one, =
  # * like: LIKE
  # * between: BETWEEN a AND b
  
  # Creates custom scope named "filterrific_sort"
  sort( 
    :sort_keys => [
      { :key => :newest_first, :label => "Newest first", :sql => "created_at DESC" },
      { :key => :alphabetically, :label => "Name (a-z)", :sql => "name ASC" },
    ],
    :default => :newest_first,
    :secondary_sorting => "name ASC" # will be appended to every sort as secondary sort key
  )
  
  # Creates custom scope named "filterrific_search"
  search(
    :columns => [:name, :email, 'provinces.name'], # default: all string columns
    :joins => :province,
    :case_sensitive => false, # adds downcase parts to term_processor and SQL query if false
    :term_splitter => /\s+/,
    :wild_card_processor => Proc.new({ |e| "%#{ e }%" }) OR Proc.new({ |e| e.gsub('*', '%') }),
    :default => "some query",
    :param_name => "search" # somebody might want to set it to "q"
  )
  # Alternative search: delegate to pg_search for fulltext search on Postgres

  # If true, prints auto generated and used scopes, current filterrific params, whether all DB
  # columns have indices
  config :debug => true # should there be different log levels? option to set output (log, puts)
  # Prefix is applied to scopes that are available to filterrific. Note that this is different
  # from the param_prefix that can be set in the controller config.
  config :scope_prefix => "filterrific_" # default, somebody might want to shorten or remove prefix
  
end

scope :some_complex_scope, lambda { |a_value| ... }


# xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx


filterrific do

  # Creates custom scope "filterrific_person". Finds all records that have one of the given values
  # in :person_ids column
  # Q: Could I skip the :assciation => true piece? Filterrific could figure this out automatically
  filter :person, :association => true # instead of true, could be an association name, e.g. :user
  filter :association => :person # alternative syntax A
  association :person # alternative syntax B
  # Creates custom scope "filterrific_active_only". Finds all records that have one of the given
  # values for :is_active column
  filter :active_only, :column => :is_active || :some_scope_name, :default => true
  filter :column => :is_active, :default => true # alternative syntax A
  column :is_active, :default => true # alternative syntax B
  # Creates custom scope "filterrific_created_after". Finds all records that have created_at after
  # the given DateTime
  filter :created_after, :column => :created_at, :default => Proc.new { 2.years.ago.beginning_of_year }
  # Creates custom scope "filterrific_complicated_scope". Delegates to an already existing scope
  # named :complicated_scope_name
  # Q: How does it know the params expected by :complicated_scope_name?
  # A: scope :filterrific_complicated_scope_name, lambda { |*attrs| complicated_scope_name(attrs) }
  filter :complicated_scope, :use_scope => :complicated_scope_name
  filter :scope => :complicated_scope_name # alternative syntax A
  scope :complicated_scope_name # alternative syntax B
  
  # Creates custom scope named "filterrific_sort"
  sort( 
    :sort_keys => [
      { :key => :newest_first, :label => "Newest first", :sql => "created_at DESC" },
      { :key => :alphabetically, :label => "Name (a-z)", :sql => "name ASC" },
    ],
    :default => :newest_first,
    :secondary_sorting => "name ASC" # will be appended to every sort as secondary sort key
  )
  
  # Creates custom scope named "filterrific_search"
  search(
    :columns => [:name, :email, 'provinces.name'], # default: all string columns
    :joins => :province,
    :case_sensitive => false, # adds downcase parts to term_processor and SQL query if false
    :term_splitter => /\s+/,
    :wild_card_processor => Proc.new({ |e| "%#{ e }%" }) OR Proc.new({ |e| e.gsub('*', '%') }),
    :default => "some query",
    :param_name => "search" # somebody might want to set it to "q"
  )

  # If true, prints auto generated and used scopes, current filterrific params, whether all DB
  # columns have indices
  config :debug => true # should there be different log levels? option to set output (log, puts)
  config :param_prefix => "filterrific_" # default, somebody might want to shorten or remove prefix
  
  auto generate from association
  auto generate from column
  delegate to existing scope
  sort auto or refer
  search auto or refer
  
end

scope :complicated_scope_name, lambda { |...| }


# xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

filterrific do

  filter :publication_date_min,
    :use_scope => :publication_date_min,
    :default => lambda { Date.new(Date.today.year, 1, 1).to_s(:calendar_display_area) }
  # need to handle date pre-processing (condition_publication_date_for_named_scope)
  filter :publication_date_max,
    :column => :publication_date,
    :condition => :on_or_before,
    :default => lambda { Date.new(Date.today.year + 3, 12, 31).to_s(:calendar_display_area) }
  filter :group, :belongs_to => true, :default => Language.all.map(&:id)
  filter :language, :belongs_to => true
  filter :owner, :belongs_to => true # could find the association automatically. Don't need belongs_to here
  filter :person, :use_scope => :with_person
  filter :programme, :belongs_to => true, :default => Programme.all.map(&:id)
  filter :publication_status, :belongs_to => true, :default => [1, 2, 5, 7]
  filter :publication_type,
    :belongs_to => true,
    :default => PublicationType.all.map(&:id) - [PublicationType.find_partner.nil_or(:id)]
  filter :role_type, :use_scope => :with_role_type
  filter :department, :use_scope => :for_department
  
  # or just referencing stuff that already is declared in the class
  belongs_to :group # creates scope 'filterrific_with_group'
  belongs_to :language, :default => Language.all.map(&:id)
  belongs_to :owner, :default => Programme.all.map(&:id)
  belongs_to :programme
  belongs_to :publication_status, :default => [1, 2, 5, 7], :param_name => :status
  belongs_to :publication_type, :default => PublicationType.all.map(&:id) - [PublicationType.find_partner.nil_or(:id)]
  
  scope :publication_date_min, :default => lambda { Date.new(Date.today.year, 1, 1).to_s(:calendar_display_area) }
  scope :publication_date_max, :default => lambda { Date.new(Date.today.year + 3, 12, 31).to_s(:calendar_display_area) }
  scope :with_person
  scope :with_role_type
  scope :for_department
  scope :with_sales_item_status, :default => %w[sales_item non_sales_item],
  scope :with_commercial_title_status, :default => %w[commercial_title non_commercial_title]
  
  column: checks for inclusion
  
  flag: the sales item checkboxes in PTS
  
  search :columns => [:short_title], :param_name => "search_short_title"

  # Two modes: auto generate or manual. If auto, can generate two directions. Manual will always
  # generate one direction only.
  # Distinction: :order-option given? ? :manual : :auto
  #
  # common options: :key, :label (default: key.to_s.titleize), :apply_secondary_sorting (default: true)
  # auto only options: :directions (default: [:asc, :desc]),
  # manual only options: :order, :joins
  sort(
    [
      { :key => :newest_first, :label => "Newest first", :order => "publications.created_at DESC" },
      { :key => :alphabetically, :label => "Name (a-z)", :order => "users.name ASC", :joins => :users }
      # creates sort_options extent_asc and extent_desc. Label is defined here on each sort_key.
      # Would be cumbersome in view.
      # Creates sort: order("publications.extent ASC, <secondary sort>"), label: "Extent Asc" and
      #               order("publications.extent DESC, <secondary sort>"), label: "Extent Desc"
      { :key => :extent, :directions => [:asc, :desc] }, # [:asc, :desc], :asc, :desc, [:asc]
      { :key => :id },
      { :key => :owner_id },
      { :key => :paf_status_id },
      { :key => :project_manager_name, :label => "PM" },
      { :key => :publication_date },
      { :key => :publication_type },
      { :key => :sales_item },
      { :key => :short_title },
      { :key => :updated_at, :apply_secondary_sorting => false },
      { :key => :programme_asc, :order => "lower(programmes.name) ASC", :joins => :programme },
      { :key => :language_asc, :order => "lower(languages.name) ASC", :joins => :language },
      { :key => :status, :order => "lower(publication_statuses.name) ASC", :joins => :publication_status }
    ],
    :default => :newest_first,
    :param_name => :sort,
    :case_sensitive => false # this uses the lower() SQL modifier around any string columns for auto generated search options
    :secondary_sorting => {
      :order => "publications.publication_date asc, lower(publications.short_title) asc, publications.id asc",
      :joins => :paf_status
    }
  )
  
end


# have to use :include instead of :joins for :roles. If I use :joins, it does an inner join and
# returns duplicates for publications. Same for :with_role_type scope.
# roles is a habtm relation with publication.
named_scope :with_person, lambda{ |person_ids|
  {
    :conditions => ["roles.person_id IN (?)", [*person_ids].map(&:to_i)],
    :include => :roles
  }
}
named_scope :with_role_type, lambda{ |role_type_ids|
  {
    :conditions => ["roles.role_type_id IN (?)", [*role_type_ids].map(&:to_i)],
    :include => :roles
  }
}
named_scope :for_department, lambda{ |department_ids|
  phase_boundary_event_types = Department.find(
    [*department_ids].map(&:to_i)
  ).map(&:phase_boundary_event_types).flatten
  { :conditions => ["events.event_type_id IN (?)", phase_boundary_event_types.map(&:id)], :joins => :events }
}
named_scope :with_sales_item_status, lambda{ |statuses|
  v = ['1 = 2'] # never true, used if no checkbox is checked ("0")
  v << 'publications.sales_item = 1'  if statuses.include?("sales_item")
  v << 'publications.sales_item != 1'  if statuses.include?("non_sales_item")
  { :conditions => v.join(' OR ') }
}
named_scope :with_commercial_title_status, lambda{ |statuses|
  v = ['1 = 2'] # never true, used if no checkbox is checked ("0")
  v << 'publications.service_category_id = 1'  if statuses.include?("commercial_title")
  v << 'publications.service_category_id != 1'  if statuses.include?("non_commercial_title")
  { :conditions => v.join(' OR ') }
}




# xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx













# Defines a filter available to Filterrific
#
# Filters are used to retrieve a subset of all records available, based on a given criterion.
# Filterrific uses Rails' scopes for this purpose. For each filter specified, Filterrific will
# create a new scope with the name "filterrific_#{ filter_key }".
#
# Filter type option
#
# This option tells Filterrific about the kind of filter required. If not given, F tries to figure
# out the filter type from the filter_key, in the following order:
#
# 1) ActiveRecord association on the model with the same name as filter_key
# 2) Column in the model's table with the same name as filter_key
# 3) Existing scope on the model with the same name as filter_key
#
# Accepts:
# 
# * :association(better belongs_to???) - this filter acts on an ActiveRecord association, typically a belongs_to.
#   Expects: true (F uses the filter_key as association name) or the name of the association as
#   Symbol or String.
# * :column - this filter acts on a column on this model's table. Filterrific looks at the column
#   type to determine what kind of scope is required. See below for column_type specific options.
#   Expects: true (F uses the filter_key as column_name) or the name of the column as Symbol or String.
# * :use_scope - accepts Symbod/String to delegate to an existing scope that is already defined on the
#   model. Alternatively accepts a Proc to define a scope within filterrific. Use the same syntax
#   as for Rails scopes.
#   Expects: true (F uses the filter_key as scope_name) or the name of the scope as Symbol or String.
# 
# General options
#
# These options are applicable to all filter types
#
# * :default - the default value for this filter. Used on first call and after reset_filterrific.
#   Set this on any filter that has a default setting.
add param name?
#
# SQL Options
#
# These options are applicable for filters that generate SQL
#
# * :joins => tables to join
# * :includes => tables to include
#
# Date filter options
#
# These options are applicable to a filter of type :column where the column is of type date.
# 
# * :condition - Expects one of :before, :after, :between, :on_or_after, :on_or_before, :at_or_after, :at_or_before
# 
# @param [Symbol, String] filter_key the key to be used for this filter
# @param [Hash] opts the options to specify this filter
# @return ?
#
filter(filter_key, filter_type, opts = {})
end


# Defines sorting for Filterrific
#
# Sort is a special type of filter. It is used to allow a user to choose the sorting of a collection.
#
# Uses sort_key as internal identifier and also as name for the form param. Creates a scope named
# "filterrific_#{ sort_key }".
#
# Options if using Filterrific internal sort
# 
# * :sort_keys - A hash for each sort key with the following options:
# ** :key - internal name for this sort key. If no :sql given, sorts by column with this name
# ** :label - label for this sort key, used in views. ?? Shouldn't this be in view helpers?'
# ** :sql - a SQL fragment used as is to specify sorting
# ** :joins - joins to be performed for sorting
# * :secondary_sorting - sort_key that will be appended to every sort as secondary sort key
# * :default - the :key of the default sort order
# * :joins - joins to be added to every sort operation (might be required for secondary sorting)
#
# Options if using existing scope for sort
# 
# * :scope - the name of an existing scope to be used for sort
# * :default - the :key of the default sort order
#
# @param [Array<Hash>] sort_options the sort options to be offered
# @param [Hash] opts the options to specify sorting
# @return ?
#
def sort(sort_options, opts = {})
end


# Defines search for Filterrific.
# Search is a special type of filter. It is used to retrieve records from the database that match
# a given search string. This is typically not as powerful as an indexed search engine, however
# it can be sufficient in a large number of use cases and is a lot simpler to set up than an index
# search server like Solr or Lucene (verify search server list!!!).
#
# Uses search_key as internal identifier and also as name for the form param. Creates a scope named
# "filterrific_#{ search_key }".
#
# Options if using Filterrific internal search
#
# * :columns => [:name, :email, 'provinces.name'], # default: all string columns
# * :joins => :province
# * :case_sensitive => false, (adds downcase parts to term_processor and SQL query if false)
# * :term_splitter => /\s+/
# * :wild_card_processor => Proc.new({ |e| "%#{ e }%" }) OR Proc.new({ |e| e.gsub('*', '%') })
# * :default - the value for the default search string. Default: nil
#
# Options if using existing scope for search
#
# * :scope => :fancy_search # name of an existing scope to be used for search
# * :default - the value for the default search string. Default: nil
#
# @param [Symbol, String] search_key the key to be used for searching
# @param [Hash] opts the options to specify searching
# @return ?
#
# * CVIMS Content looks like a good and general solution
#
def search(search_key, opts = {})
end


# Configures one or more aspects of Filterrific.
#
# Available Config options
#
# * :debug => true or output type (log, stdout)
# * :sql_type => :mysql (or :postgresql), possible oracle? Determines how search is handled (regex
#   vs. like), and any other differences. Could we use Rails' DB connectors for this?
#
# @param [Hash] opts the config options
# @return ?
#
def config(opts = {})
end




Auto generated scopes for author:

* belongs_to: scope :filterrific_with_author_ids, lambda { |author_ids| where({ :author_id => *[author_ids] }
* has_many: scope exists?
* collection
* attribute [String]
* attribute [Numeric]
* attribute [Date, DateTime]
* attribute [Boolean,TinyInt]
* attribute [Text]
* 

Each type uses a kind of Filterrific::Matcher:

* search
* date_time
* foreign_key



MODEL
=====

filterrific do

  associations do
    person # creates a scope for filterrific
    state, :default => [1,2,3,4], :type => :select, :multiple => 4
  end
  
  scopes do
    active_only, :default => true # refers to already defined scope
    search, :as => "q" (optional param name override)
    sorted_by, :default => "created_at_desc"
  end
  
  config :debug => true  # prints auto generated and used scopes, current filterrific params, whether all DB columns have indices
  config ... can't think of any other config options yet.
end

scope :search, ...
