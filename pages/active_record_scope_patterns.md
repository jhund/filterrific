---
layout: default
---

{% include project_navigation.html %}

ActiveRecord scope patterns
===========================

Filterrific makes heavy use of ActiveRecord scopes. This page provides some
patterns for common scoping applications:

* belongs_to associations
* has_many associations
* exists
* search
* sort
* ranges
* tristate


belongs_to associations
-----------------------

Naming convention: `with_[foreign_key]`

```ruby
scope :with_user_id, lambda { |user_ids|
  where(:user_id => [*user_ids])
}
```

This scope accepts both a single value as well as an array of values. Both will
be cast to arrays, so the resulting SQL WHERE clause will use 'IN'.



has_many associations
---------------------



Exists: many to many
--------------------

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



Not exists: has_many
--------------------

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




Exists: has_many
----------------

scope :with_group_membership_exists, lambda {
  where(
    "EXISTS (SELECT 1 from users u, group_memberships gm WHERE u.id = gm.user_id)"
  )
}



Search
------

### MySQL

```ruby
scope :search_query, lambda { |query|
}
```



### Postgres with regex



### Postgres with indexed search

TBD



Sort
----

```ruby
scope :sorted_by, lambda { |query|
}
```

Note: Try to stick with this name as `sort_by` caused conflicts in the past.



Ranges
------

* semi open intervals
