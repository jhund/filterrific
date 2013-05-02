---
layout: default
---

Filterrific example application
===============================

{% include project_navigation.html %}

All patterns and instructions in this documentation refer to the example
Rails application below.

We have designed it with the primary goal of demonstrating all Filterrific features
with as little code as possible. In a production app you would have to add
things like permissions, etc.

Models
------

<img src="/images/example_application_class_structure.png" alt="Example application class structure" class="img-polaroid" />
<div class="img_caption">Class structure of the example application</div>

The `User` class is our primary class which we will filter using Filterrific.

```ruby
# app/models/user.rb
class User < ActiveRecord::Base
  # db columns:
  # integer: id
  # integer: country_id
  # datetime: created_at
  # text: email
  # string: gender
  # string: name
  # integer: login_count

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

  scope :with_gender, lambda { |a_gender|
    where(:gender => [*a_gender])
  }
  scope :with_country_id, lambda { |a_country_id|
    where(:country_id => [*a_country_id])
  }
  scope :with_login_count_gte, lambda { |a_login_count|
    where('users.login_count >= ?', a_login_count)
  }
  scope :with_role_ids, lambda { |role_ids|
    # exists magic
  }
  scope :search_query, lambda { |query|
  }
  scope :sorted_by, lambda { |sort_key|
  }

end
```

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

```ruby
# app/models/role.rb
class Role < ActiveRecord::Base
  # db columns:
  # integer: id
  # string: name

  has_many :role_assignments
end
```

```ruby
# app/models/country.rb
class Country < ActiveRecord::Base
  # db columns:
  # integer: id
  # string: name

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

