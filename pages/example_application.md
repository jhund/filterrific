---
layout: default
---

<div class="page-header">
  <h2>Example application</h2>
</div>



{% include project_navigation.html %}

All patterns and instructions in this documentation refer to the filterrific
demo Rails application below. You can view a
[live demo](http://filterrific-demo.herokuapp.com), and the source for the demo
app on github:
[github.com/jhund/filterrific_demo](https://github.com/jhund/filterrific_demo).

I have included only the parts of the code required to demonstrate Filterrific.
In a production app you would have to add a lot more code to handle permissions,
strong params, etc.

The `Student` model is the primary model which we will filter. It belongs to
the `Country` class as shown below:

Class structure
---------------

<img src="/images/example_application_class_structure.png" alt="Example application class structure" class="img-polaroid" />
<div class="img_caption">Class structure of the example application</div>


### Student

The `Student` class is our primary class. This is where we include Filterrific.

```ruby
# app/models/student.rb
class Student < ActiveRecord::Base
  # db columns:
  # integer: id
  # string: first_name
  # string: last_name
  # text: email
  # integer: country_id
  # datetime: created_at

  belongs_to :country
end
```

### Country

The `Country` class represents the country a `Student` belongs to, e.g.,
&ldquo;Canada&rdquo;, &ldquo;United States&rdquo;, and &ldquo;Australia&rdquo;.

Not all students belong to a country.

```ruby
# app/models/country.rb
class Country < ActiveRecord::Base
  # db columns:
  # integer: id
  # string: name

  has_many :students
end
```


<a href="/pages/active_record_model_api.html" class='btn btn-success'>Learn about the Model API &rarr;</a>
