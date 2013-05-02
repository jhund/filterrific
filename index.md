---
layout: default
---

{% include project_navigation.html %}

# Filterrific

Some intro text...

````
class User < ActiveRecord::Base
  # db columns:
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

class RoleAssignment < ActiveRecord::Base
  belongs_to :role
  belongs_to :user
end

class Role < ActiveRecord::Base
  has_many :role_assignments
end

scope :with_gender, lambda { |a_gender|
  where(:gender => [*a_gender])
}
# Note: [*a_gender] casts a_gender to an array, no matter whether you pass in a single string or an array of strings.
scope :with_country_id, lambda { |a_country_id| where(:country_id => [*a_country_id]) }
scope :with_login_count_gte, lambda { |a_login_count| where('users.login_count >= ?', a_login_count) }
# It's good to have a convention when working with ranges and intervals. One such convention is
# to include the lower bound and exclude the upper bound (semi open interval).
# That's why we use greater than or equal
scope :with_role_ids, lambda { |role_ids|
  # exists magic
}
scope :search_query, lambda { |query|
}
scope :sorted_by, lambda { |sort_key|
}

````
