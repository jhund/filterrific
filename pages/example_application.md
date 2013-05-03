---
layout: default
---

<div class="page-header">
  <h2>Example application</h2>
</div>



{% include project_navigation.html %}

All patterns and instructions in this documentation refer to the example
Rails application below.

We have included only the parts of the code required to demonstrate Filterrific.
In a production app you would have to add a lot more code to handle permissions,
strong params, etc.

The `User` model is the primary model which we will filter, and which has
associations to a number of other classes as shown in the class structure below:

Class structure
---------------

<img src="/images/example_application_class_structure.png" alt="Example application class structure" class="img-polaroid" />
<div class="img_caption">Class structure of the example application</div>


### User

The `User` class is our primary class. This is where we include Filterrific.

```ruby
# app/models/user.rb
class User < ActiveRecord::Base
  # db columns:
  # integer: id
  # string: name
  # text: email
  # string: gender
  # integer: country_id
  # datetime: created_at

  belongs_to :country
  has_many :comments
  has_many :role_assignments
  has_many :roles, :through => :role_assignments

end
```

### Comment

A `User` can have many `Comments`.

```ruby
# app/models/comment.rb
class Comment < ActiveRecord::Base
  # db columns:
  # integer: id
  # integer: user_id
  # text: body
  # datetime: created_at

  belongs_to :user
end
```

### RoleAssignment

The `RoleAssignment` class joins `User` and `Role` via a many-to-many association.
That means each `User` can have many `Roles`, and each `Role` can have many
`Users`.

```ruby
# app/models/role_assignment.rb
class RoleAssignment < ActiveRecord::Base
  # db columns:
  # integer: id
  # integer: role_id
  # integer: user_id

  belongs_to :role
  belongs_to :user
end
```

### Role

The `Role` class represents the roles in the app, e.g., &ldquo;Admin&rdquo;, &ldquo;Registrar&rdquo;,
&ldquo;Teacher&rdquo;, and &ldquo;Student&rdquo;.

```ruby
# app/models/role.rb
class Role < ActiveRecord::Base
  # db columns:
  # integer: id
  # string: name

  has_many :role_assignments
  has_many :users, :through => :role_assignments
end
```

### Country

The `Country` class represents the country a `User` belongs to, e.g.,
&ldquo;Canada&rdquo;, &ldquo;United States&rdquo;, and &ldquo;Germany&rdquo;.

Not all users belong to a country.

```ruby
# app/models/country.rb
class Country < ActiveRecord::Base
  # db columns:
  # integer: id
  # string: name

  has_many :users
end
```


<div class="pull-right">
  <a href="/pages/active_record_model_api.html" class='btn btn-success'>Learn about the Model API &rarr;</a>
</div>
