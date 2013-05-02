---
layout: default
---

{% include project_navigation.html %}

Filterrific example application
===============================

All patterns and instructions in this documentation refer to the example
Rails application below.

We have designed it with the goal to demonstrate all Filterrific features.

Models
------

```ruby
# app/models/user.rb
class User < ActiveRecord::Base
  # db columns:
  # id: integer
  # country_id: :integer
  # created_at: :datetime
  # email: :string
  # gender: :string
  # name: :string

  filterrific(
    :defaults => {
      :sorted_by => 'users.created_at DESC'
    },
    :scope_names => %w[
      search_query
      sorted_by
      with_country_id
      with_created_at_gte
      with_created_at_lt
      with_gender
      with_role_id
    ]
  )

  belongs_to :country
  has_many :role_assignments
  has_many :roles, :through => :role_assignments
  has_many :

end
```

```ruby
class RoleAssignment < ActiveRecord::Base
  # db columns:
  # id: integer
  # role_id: integer
  # user_id: integer

  belongs_to :role
  belongs_to :user
end
```

```ruby
class Role < ActiveRecord::Base
  # db columns:
  # id: integer
  # name: string

  has_many :role_assignments
end
```

```ruby
class Country < ActiveRecord::Base
  has_many :users
end
```

Controller
----------

```ruby
# app/controllers/users_controller.rb
class UsersController < ApplicationController

  def index
  end

end
```

Views
-----

