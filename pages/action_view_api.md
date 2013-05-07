---
layout: default
---

<div class="page-header">
  <h2>View API</h2>
</div>

{% include project_navigation.html %}

Use the Filterrific ActionView API to:

* Display the list of matching records and the form to update filter settings.
* Update the filter settings via AJAX form submission.
* Reset the filter settings.

Filterrific works best with AJAX updates. The library comes with form observers
for jQuery, and a spinner to indicate that the list is being refreshed.

Please see below for all the view files involved:

### index.html

This is the main template for the users list. It is rendered on first load
and includes:


* The `_list.html.erb` partial for the actual list of users. When we refresh
  the list, we just update the `_list.html.erb` partial via AJAX.
* `render_matching_users_count` from the `UsersHelper`. This is also refreshed
  via AJAX.
* The Filterrific filter form.

You can use any type of form input type for the filter. We have had great
success with Harvest's [Chosen](http://harvesthq.github.io/chosen/) multi select.


```erb
<%# app/views/users/index.html.erb %>
<h1>Users</h1>

<div id="results_count">
  <%= render_matching_users_count(@users.total_entries) %>
</div>

<%# give the form the 'filterrific_filter' class for automatic AJAX updates on change %>
<%= form_for(
  @filterrific,
  :as => :filterrific,
  :html => {
    :method => :get,
    :onsubmit => 'return false;',
    :id => 'filterrific_filter'
  }) do |f|
%>
  <div>
    Search
    <%# give the search field the 'js-periodically-observed' class for live updates %>
    <%= f.text_field(
      :search_query,
      :class => 'js-periodically-observed'
    ) %>
  </div>
  ...
  <div>
    Gender
    <%= f.select(
      :with_gender,
      [['Male', 'm'], ['Female', 'f'], ['Other', 'o']],
      { :include_blank => '- Any -' }
    ) %>
  </div>
  <div>
    Sorted by
    <%= f.select(
      :sorted_by,
      [ ['Name (a-z)', 'name_asc'],
        ['Most recent sign ups', 'created_at_desc'],
        ['Country (a-z)', 'country_name_asc']],
      { :include_blank => '- Any -' }
    ) %>
  </div>
  <div>
    <%= link_to(
      'Reset filters',
      reset_filterrific_users_path,
    ) %>
  </div>
  <%# add an automated spinner to your form when the list is refreshed %>
  <%= render_filterrific_spinner %>
<% end %>

<%= render(
  :partial => 'users/list',
  :locals => { :users => @users }
) %>
```

### UsersHelper

This helper renders the count of users who match the filter settings. We wrap
it in a helper so that we can call it both on initial page load, as well as from
the AJAX response.

```ruby
# app/helpers/users_helper.rb
module UsersHelper

  def render_matching_users_count(count)
    if 1 == count
      "1 user matches the filter settings."
    else
      "#{ count } users match the filter settings."
    end
  end

end
```

### _list.html

The `_list.html.erb` partial renders the actual list of users. We extract it
into a partial so that we can update it via AJAX response.

```erb
<%# app/views/users/_list.html.erb %>
<div id="filterrific_results">
  <table>
    <tr>
      <th>Name</th>
      <th>Email</th>
      <th>Country</th>
    </tr>
    <% users.each do |user| %>
      <tr>
        <td>
          <%= link_to(user.name, user_path(user)) %>
        </td>
        <td><%= user.email %></td>
        <td><%= user.country_name %></td>
      </tr>
    <% end %>
  </table>
</div>

<%= will_paginate users %>
```

### index.js

This javascript template updates the users list after the filter settings
were changed.

```erb
<%# app/views/users/index.js.erb %>
<% js = escape_javascript(
  render(:partial => 'users/list', :locals => { :users => @users })
) %>
$("#filterrific_results").html("<%= js %>");
$("#results_count").html("<%= render_matching_users_count(@users.total_entries) %>")
```

### application.js

If you use jQuery and the asset pipeline, then just add this line to your
application.js file to get the form observers and the spinner:

```javascript
//= require filterrific-jquery
```

<div class="pull-right">
  <a href="/pages/active_record_scope_patterns.html" class='btn btn-success'>Learn about scope patterns &rarr;</a>
</div>
