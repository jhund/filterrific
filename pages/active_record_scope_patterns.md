---
layout: default
---

ActiveRecord scope patterns
===========================

{% include project_navigation.html %}

Filterrific makes heavy use of ActiveRecord scopes. This page provides resources
to help you write awesome scopes for powerful filtering.

Please refer to the [example application](/pages/example_application.html) to better understand the patterns below.


Common scoping patterns
-----------------------

* Selected values for belongs_to association
* Selected values for has_many association
* Exists: has_many association
* Not exists: has_many association
* Exists: many-to-many association
* Not exists: many-to-many association
* Searching
* Sorting
* Ranges
* Scopes vs. Class methods


### Selected values for belongs_to association

Naming convention: `with_[foreign_key]`

```ruby
scope :with_user_id, lambda { |user_ids|
  where(:user_id => [*user_ids])
}
```

This scope accepts both a single value as well as an array of values. Both will
be cast to arrays, so the resulting SQL WHERE clause will use 'IN'.

Note: [*a_gender] casts a_gender to an array, no matter whether you pass in a single string or an array of strings.


### Selected values for has_many association


### Exists: has_many association

scope :with_group_membership_exists, lambda {
  where(
    "EXISTS (SELECT 1 from users u, group_memberships gm WHERE u.id = gm.user_id)"
  )
}



### Not exists: has_many association

If further conditions need to be applied:
scope :except_fee_paying, lambda {
  where(
    %(
      NOT EXISTS (
        SELECT 1
          FROM group_memberships gm, training_payments tp,
         WHERE tp.group_membership_id = gm.id
           AND tp.state = 'successful'
           AND tp.trigger_type = 'PaypalTxn'
      )
    )
  )
}

If no further conditions need to be applied to friends:
Person.includes(:friends).where( :friends => { :person_id => nil } )
Test if this really works! got it from stack overflow:
http://stackoverflow.com/questions/5319400/want-to-find-records-with-no-associated-records-in-rails-3




### Exists: many-to-many association

When joining on a many-to-many relationship, we can get duplicate results.

Example: publications -> roles

I have tried using select('DISTINCT(publications.*')), however that caused issues
where we used more joins in the sorted_by scope and the sort keys were not
part of the select statement.

Here is what worked: On many-to-many relations, don't use join. Use EXISTS and
a subquery instead:

This DOESN'T WORK (will result in duplicate publications, one for each role):

  scope :with_person, lambda{ |person_ids|
    where(['roles.person_id IN () ?', [*person_ids].map(&:to_i)]).joins(:roles)
  }

This WORKS

  scope :with_person, lambda{ |person_ids|
    roles = Role.arel_table
    publications = Publication.arel_table
    where(
      Role.where(roles[:publication_id].eq(publications[:id])) \
           .where(roles[:person_id].in([*person_ids].map(&:to_i))) \
           .exists
    )
  }



### Not exists: many-to-many association


### Searching

#### MySQL with `LIKE`

```ruby
scope :search_query, lambda { |query|
}
```

* asterisk trick

#### Postgres with `LIKE`

#### Postgres with regex



#### Postgres with indexed search

TBD



### Sorting

```ruby
scope :sorted_by, lambda { |query|
}
```

Note: Try to stick with this name as `sort_by` caused conflicts in the past.



### Ranges

* semi open intervals
  # It's good to have a convention when working with ranges and intervals. One such convention is
  # to include the lower bound and exclude the upper bound (semi open interval).
  # That's why we use greater than or equal

naming convention: gte and lt


### Scopes vs. Class methods

can class methods be chained like scopes?

http://blog.plataformatec.com.br/2013/02/active-record-scopes-vs-class-methods/
