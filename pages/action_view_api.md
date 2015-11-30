---
layout: default
nav_id: view_api
---

<div class="page-header">
  <h2>View API</h2>
</div>

{% include site_navigation.html %}

Use the Filterrific ActionView API to:

* Display the list of matching records and the form to update filter settings.
* Update the filter settings via AJAX form submission.
* Reset the filter settings.

Filterrific works best with AJAX updates. The library comes with form observers
for jQuery and an AJAX spinner. See below for a code example without AJAX.

### View example 1
<p class="unconstrained">
  <img src="/images/screenshot_s.png" alt="Filterrific in action" class="img-polaroid" />
  <div class="img_caption">
    Example 1: The example app's student list.
  </div>
</p>

### View example 2

<p class="unconstrained">
  <img src="/images/screenshot_c.png" alt="Filterrific in action" class="img-polaroid" />
  <div class="img_caption">
    Example 2: Filtering a list of members, with saved searches,
    pagination and filter reset. List at the left, filters to the right.
  </div>
</p>


### View example 3

<p class="unconstrained">
  <img src="/images/screenshot_q.png" alt="Filterrific in action" class="img-polaroid" />
  <div class="img_caption">
    Example 3: Filtering a list of questions. Filters above, list below.
  </div>
</p>




## View code walk through

### index.html

This is the main template for the students list. It is rendered on first load
and includes:

* The Filterrific filter form.
* The `_list.html.erb` partial for the actual list of students. When we refresh
  the list, we just update the `_list.html.erb` partial via AJAX.

You can use any type of form inputs for the filter. For multiple selects
we have had great success with Harvest's
[Chosen](http://harvesthq.github.io/chosen/) multi select input widget.


```erb
<%# app/views/students/index.html.erb %>
<h1>Students</h1>

<%#
  Filterrific adds the `form_for_filterrific` view helper:
  * adds dom id 'filterrific_filter'
  * applies javascript behaviors:
      * AJAX form submission on change
      * AJAX spinner while AJAX request is being processed
  * sets form_for options like :url, :method and input name prefix
%>
<%= form_for_filterrific @filterrific do |f| %>
  <div>
    Search
    <%# give the search field the 'filterrific-periodically-observed' class for live updates %>
    <%= f.text_field(
      :search_query,
      class: 'filterrific-periodically-observed'
    ) %>
  </div>
  <div>
    Country
    <%= f.select(
      :with_country_id,
      @filterrific.select_options[:with_country_id],
      { include_blank: '- Any -' }
    ) %>
  </div>
  <div>
    Registered after
    <%= f.text_field(:with_created_at_gte, class: 'js-datepicker') %>
  </div>
  <div>
    Sorted by
    <%= f.select(:sorted_by, @filterrific.select_options[:sorted_by]) %>
  </div>
  <div>
    <%= link_to(
      'Reset filters',
      reset_filterrific_url,
    ) %>
  </div>
  <%# add an automated spinner to your form when the list is refreshed %>
  <%= render_filterrific_spinner %>
<% end %>

<%= render(
  partial: 'students/list',
  locals: { students: @students }
) %>
```

### _list.html

The `_list.html.erb` partial renders the actual list of students. We extract it
into a partial so that we can update it via AJAX response.

```erb
<%# app/views/students/_list.html.erb %>
<div id="filterrific_results">

  <div>
    <%= page_entries_info students # provided by will_paginate %>
  </div>

  <table>
    <tr>
      <th>Name</th>
      <th>Email</th>
      <th>Country</th>
      <th>Registered at</th>
    </tr>
    <% students.each do |student| %>
      <tr>
        <td><%= link_to(student.full_name, student_path(student)) %></td>
        <td><%= student.email %></td>
        <td><%= student.country_name %></td>
        <td><%= student.decorated_created_at %></td>
      </tr>
    <% end %>
  </table>
</div>

<%= will_paginate students # provided by will_paginate %>
```

### index.js

This javascript template updates the students list after the filter settings
were changed.

```erb
<%# app/views/students/index.js.erb %>
<% js = escape_javascript(
  render(partial: 'students/list', locals: { students: @students })
) %>
$("#filterrific_results").html("<%= js %>");
```

### application.js

If you use jQuery and the asset pipeline, then just add this line to your
application.js file to get the form observers and the spinner:

```javascript
//= require filterrific/filterrific-jquery
```

## Disable AJAX auto form submits

By default Filterrific will automatically submit the filter form as soon as you change any of the filter settings. Sometimes you may not want this behavior, e.g., if the rendering of the filtered records is fairly expensive.

The auto submit behavior is triggered by the filter form's id which is automatically added by the `form_for_filterrific` helper method. In order to deactivate AJAX auto submits, just override the DOM id for the form with something other than the default of `filterrific_filter`. If you still want to submit the form via AJAX (just not automatically on every change), also add the `remote: true` option to `form_for_filterrific`. Otherwise the form will be submitted as regular POST request and the entire page will reload.

Then you must add a regular submit button, and make sure you don't add the `.filterrific-periodically-observed` class to any inputs. Now Filterrific will update the list only when you manually submit the form:

~~~ erb
<%= form_for_filterrific @filterrific, html: { id: 'filterrific-no-ajax-auto-submit' } do |f| %>
...
  <%= f.submit 'Filter' %>
<% end %>
~~~

## Sort by Column Title

Filterrific provides sortable column header links which toggle sort direction
with the `filterrific_sorting_link()` method.

### filterrific_sorting_link

The `filterrific_sorting_link(@filterrific, ...)` method provides toggle
sorting of attributes defined in a `sorted_by` scope.

```erb
<%# app/views/students/_list.html.erb %>
<div id="filterrific_results">

  <div>
    <%= page_entries_info students # provided by will_paginate %>
  </div>

  <table>
    <tr>
      <th><%= filterrific_sorting_link(@filterrific, :name) %></th>
      <th><%= filterrific_sorting_link(@filterrific, :email) %></th>
      <th><%= filterrific_sorting_link(@filterrific, :country) %></th>
      <th><%= filterrific_sorting_link(@filterrific, :registered_at) %></th>
    </tr>
    <% students.each do |student| %>
      <tr>
        <td><%= link_to(student.full_name, student_path(student)) %></td>
        <td><%= student.email %></td>
        <td><%= student.country_name %></td>
        <td><%= student.decorated_created_at %></td>
      </tr>
    <% end %>
  </table>
</div>

<%= will_paginate students # provided by will_paginate %>
```

`filterrific_sorting_link()` must be placed in the view partial.

### sorted_by

The `filterrific_sorting_link()` method is expecting a`sorted_by` scope which
contains the column headers and the model attribute to sort by. Column headers
are automatically capitalized.

```
scope :sorted_by, lambda { |sort_option|
  direction = (sort_option =~ /desc$/) ? 'desc' : 'asc'
  case sort_option.to_s
  when /^name/
    order("LOWER(students.name) #{ direction }")
  when /^email/
    order("LOWER(students.email) #{ direction }")
  when /^country/
    order("LOWER(students.country) #{ direction }")
  when /^registered_at/
    order("LOWER(students.decorated_created_at) #{ direction }")
  else
    raise(ArgumentError, "Invalid sort option: #{ sort_option.inspect }")
  end
}
```

[More on sorting scope...](/pages/active_record_scope_patterns.html#sort)

----
<p>
  <a href="/pages/active_record_scope_patterns.html" class='btn btn-success'>Learn about scope patterns &rarr;</a>
</p>
