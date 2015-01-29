---
layout: default
nav_id: scope_patterns
---

<div class="page-header">
  <h2>Scope patterns</h2>
</div>


{% include site_navigation.html %}

Filterrific makes heavy use of ActiveRecord scopes. The controller forwards
the filter settings to the model where each filter setting is passed as argument to the
corresponding scope. This page provides resources to help you write awesome
scopes for powerful filtering. You have to add these scopes to your Filterrific
model.

Please refer to the [example application](/pages/example_application.html) to
get the context for the patterns below.


### Common scope patterns

* [Sanitize your SQL! (Security alert)](#sanitize)
* [Filter by column values](#filter_by_column_values)
* [Search](#search)
* [Sort](#sort)
* [Filter by existence of has_many association](#filter_by_existence_has_many)
* [Filter by non-existence of has_many association](#filter_by_non_existence_has_many)
* [Filter by existence of many-to-many association](#filter_by_existence_many_to_many)
* [Filter by non-existence of many-to-many association](#filter_by_non_existence_many_to_many)
* [Filter by ranges](#filter_by_ranges)
* [Multiple form inputs for single scope](#multiple_form_inputs_for_single_scope)
* [Scopes vs. Class methods](#scopes_vs_class_methods)


<a id="sanitize"></a>
### Sanitize your SQL!

It's important that all filter settings are sanitized before you apply them
to your Filterrific model. Otherwise you would allow an intruder to inject malicious
SQL code into your database.

Rails has good documentation on
[how to prevent SQL injection](http://guides.rubyonrails.org/security.html#sql-injection).

TL;DR:

* OK: `where(country_id: param)`
* OK: `where('students.country_id = ?', param)`
* NOT OK: `where("students.country_id = '#{ param }'")`

Note that attribute mass assignment issues do not apply here since we're only
reading data from the database, and not writing to it.

I love this [XKCD cartoon about SQL injection](http://xkcd.com/327/)!




<a id="filter_by_column_values"></a>
### Filter by column values

This is the simplest type of scope. You can use it to filter records
with a given attribute or foreign key of a `belongs_to` association.

Scope naming convention: `with_%{column name}`.

```ruby
# filters on 'country_id' foreign key
scope :with_country_id, lambda { |country_ids|
  where(country_id: [*country_ids])
}

# filters on 'gender' attribute
scope :with_gender, lambda { |genders|
  where(gender: [*genders])
}
```

The `country_id` scope accepts either a single value like `42`, or an array of values
like `[1, 2, 3]`. The `[*country_ids]` expression always casts it to an
array.

If you want to filter by a column value in a joined table, you can do one of the
following:

```ruby
# filters on 'name' column in 'countries' table

# using AR hash syntax ...
scope :with_country_name, lambda { |country_name|
  where(country: { name: country_name }).joins(:country)
}

# or sanitized SQL snippets for more complex needs (e.g., greater than)
scope :with_country_name, lambda { |country_name|
  where('countries.name = ?', country_name).joins(:country)
}
```


<a id="search"></a>
### Search

There are a number of ways to search for records in your relational database.

We will show you a simple example here, and just point to some more advanced
techniques further below.

The simplest form is to use SQL's `LIKE` operator. In its most basic use,
it works for both MySQL as well as PostgreSQL:

```ruby
scope :search_query, lambda { |query|
  # Searches the students table on the 'first_name' and 'last_name' columns.
  # Matches using LIKE, automatically appends '%' to each term.
  # LIKE is case INsensitive with MySQL, however it is case
  # sensitive with PostGreSQL. To make it work in both worlds,
  # we downcase everything.
  return nil  if query.blank?

  # condition query, parse into individual keywords
  terms = query.downcase.split(/\s+/)

  # replace "*" with "%" for wildcard searches,
  # append '%', remove duplicate '%'s
  terms = terms.map { |e|
    (e.gsub('*', '%') + '%').gsub(/%+/, '%')
  }
  # configure number of OR conditions for provision
  # of interpolation arguments. Adjust this if you
  # change the number of OR conditions.
  num_or_conds = 2
  where(
    terms.map { |term|
      "(LOWER(students.first_name) LIKE ? OR LOWER(students.last_name) LIKE ?)"
    }.join(' AND '),
    *terms.map { |e| [e] * num_or_conds }.flatten
  )
}
```
The above approach works for simple search functions with small to medium
size databases. If you have more advanced needs, you might consider using
regular expressions, or the PostgreSQL full text search function.

Remember that you need to use your relational database's search function, rather
than an external search service if you want to be able to combine the search
filter with other Filterrific filters.




<a id="sort"></a>
### Sort

A sorting scope allows you to set the sorting of your matching records.

Scope naming convention: `sorted_by`. We suggest to stick with this name
as we've experienced issues with other names that might collide with
ActiveRecord reserved names.

```ruby
scope :sorted_by, lambda { |sort_option|
  # extract the sort direction from the param value.
  direction = (sort_option =~ /desc$/) ? 'desc' : 'asc'
  case sort_option.to_s
  when /^created_at_/
    # Simple sort on the created_at column.
    # Make sure to include the table name to avoid ambiguous column names.
    # Joining on other tables is quite common in Filterrific, and almost
    # every ActiveRecord table has a 'created_at' column.
    order("students.created_at #{ direction }")
  when /^name_/
    # Simple sort on the name colums
    order("LOWER(students.last_name) #{ direction }, LOWER(students.first_name) #{ direction }")
  when /^country_name_/
    # This sorts by a student's country name, so we need to include
    # the country. We can't use JOIN since not all students might have
    # a country.
    order("LOWER(countries.name) #{ direction }").includes(:country)
  else
    raise(ArgumentError, "Invalid sort option: #{ sort_option.inspect }")
  end
}
```




<a id="filter_by_existence_has_many"></a>
### Filter by existence of has_many association

This scope filters records who have an associated `has_many` object. E.g.,
the scope below finds all students who have posted at least one comment.

Naming convention: `with_%{plural association name}`.

```ruby
scope :with_comments, lambda {
  where(
    'EXISTS (SELECT 1 from students, comments WHERE students.id = comments.student_id)'
  )
}
```

You can also apply conditions on the associated record, e.g., students who have
posted a comment since a given reference_time:

```ruby
scope :with_comments_since, lambda { |reference_time|
  where([
    %(
      EXISTS (
        SELECT 1
          FROM students, comments
         WHERE students.id = comments.student_id
           AND comments.created_at >= ?)
    ),
    reference_time
  ])
}
```




<a id="filter_by_non_existence_has_many"></a>
### Filter by non-existence of has_many association

Use this scope to filter records who have **NO** associated `has_many` object.
E.g., the scope below finds all students who have never posted a comment.

Naming convention: `without_%{plural association name}`.

```ruby
scope :without_comments, lambda {
  where(
    %(NOT EXISTS (
      SELECT 1 FROM students, comments WHERE comments.student_id = students.id
    ))
  )
}
```




<a id="filter_by_existence_many_to_many"></a>
### Filter by existence of many-to-many association

This scope finds any students who have a given role, using `EXISTS` and a SQL
sub query. This scope traverses the `has_many :through` association between
`Student` and `Role` via `RoleAssignment`.

Naming convention: `with_%{singular association name}_ids`

```ruby
scope :with_role_ids, lambda{ |role_ids|
  # get a reference to the join table
  role_assignments = RoleAssignment.arel_table
  # get a reference to the filtered table
  students = Student.arel_table
  # let AREL generate a complex SQL query
  where(
    RoleAssignment \
      .where(role_assignments[:student_id].eq(students[:id])) \
      .where(role_assignments[:role_id].in([*role_ids].map(&:to_i))) \
      .exists
  )
}
```

Note: you might be tempted to use a simple `WHERE` and `JOIN` clause, however
you will end up getting duplicate student records, one for each role a student
holds. You shouldn't use a `DISTINCT` clause to eliminate duplicates
since this might interfere with other scopes that we chain in the current
Filterrific query. E.g., your database might complain about sort keys not being
part of the `SELECT` statement.





<a id="filter_by_non_existence_many_to_many"></a>
### Filter by non-existence of many-to-many association

This scope finds any students who DO NOT have a given role. It is almost identical
to the previous one. We just appended the `.not` operator to invert it.

Naming convention: `without_%{singular association name}_ids`

```ruby
scope :without_role_ids, lambda{ |role_ids|
  role_assignments = RoleAssignment.arel_table
  students = Student.arel_table
  where(
    RoleAssignment \
      .where(role_assignments[:student_id].eq(students[:id])) \
      .where(role_assignments[:role_id].in([*role_ids].map(&:to_i))) \
      .exists
      .not
  )
}
```



<a id="filter_by_ranges"></a>
### Filter by ranges

This scope filters by a student's signup date range. The only important concept
to keep in mind when working with ranges is that you stay consistent with your
boundaries. We suggest to always use semi-open intervals for consistency (i.e.
you always include the lower boundary and exclude the upper boundary).

Please note that SQL's `BETWEEN` operator is inclusive, i.e. it includes both
boundaries.

Scope naming convention: `with_%{column name}_gte` and `with_%{column name}_lt`.
`gte` is an abbreviation for 'Greater than or equal' and `lt` is an abbreviation
for 'Less than'.

```ruby
# always include the lower boundary for semi open intervals
scope :created_at_gte, lambda { |reference_time|
  where('students.created_at >= ?', reference_time)
}

# always exclude the upper boundary for semi open intervals
scope :created_at_lt, lambda { |reference_time|
  where('students.created_at < ?', reference_time)
}
```



<a id="multiple_form_inputs_for_single_scope"></a>
### Multiple form inputs for single scope

Sometimes you need multiple form inputs for a single scope. An example would be
a scope that finds locations within a certain distance from a city. You'd need
two inputs: one for the maximum distance, and one to choose a city.

You can accomplish this using Rails' `fields_for` form helper. It allows you
to combine more than one form input's value into a single param. So here is what
you do:

You will use a scope called `with_distance`. You declare it as usual in the
`filterrific` directive at the top of your model.

Here is the view code, using `fields_for`:

```erb
<%# app/views/students/index.html.erb
  Add a `fields_for` helper to your filterrific form:
%>
<%= form_for @filterrific do |f| %>
  ...
  <div>
    Distance
    <%= f.fields_for :with_distance do |with_distance_fields| %>
      <%= with_distance_fields.text_field :max_distance %>
      <%= with_distance_fields.text_field :city %>
    <% end %>
  </div>
  ...
```

Then you specify the scope like so:

```ruby
scope :with_distance, lambda { |distance_attrs|
  # `distance_attrs` is a hash with two keys:
  # {
  #   :max_distance => '10',
  #   :city => 'Vancouver',
  # }
  where(...)
}
```



<a id="scopes_vs_class_methods"></a>
### Scopes vs. Class methods

In certain cases, you can replace scopes with class methods. We recommend to
use scopes. Please read this blog post to learn more:

[http://blog.plataformatec.com.br/2013/02/active-record-scopes-vs-class-methods/](http://blog.plataformatec.com.br/2013/02/active-record-scopes-vs-class-methods/)

<p>
  <a href="http://clearcove.ca/open-source/" class='btn btn-success'>
    Check out more ClearCove open source projects &rarr;
  </a>
</p>

