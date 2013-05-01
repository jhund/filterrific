20110418: Look at this when building API: https://github.com/ryan-allen/lispy


20110414 Related project:

* https://github.com/plataformatec/has_scope


20110221 Promotion:

* railscasts (even ask for review/feedback)
* railsinside
* ruby toolbox


20110205: figuring out best prefix for namespacing filterrific

balance between shortness and expression:

f
fc
ft
frc
ftf
fifc
flfc
frfc
ftfc
ftrfc
fltrfc
filtrfc
filterrific

20110112: see if I can learn something here:
http://www.idolhands.com/ruby-on-rails/guides-tips-and-tutorials/add-filters-to-views-using-named-scopes-in-rails


20101227: get inspiration from this project: https://github.com/neerajdotname/admin_data
look especially at their query builder in the heroku demo project (add conditions like Finder search)


Glean specific code from these projects:

20100224 CVIMS
201001   cando
201001   PTS
201001   Quentin-rails-backend
         stratadocs (list starts with self as AR proxy)


view
(skip these for now?)
apply all relevant options from formtastic
integrate with formtastic?








## CONTENT FOR README


This Rails engine makes it super simple to add filtering to your rails list views.

### Some of the features:

* RESTful
* conditions, sorting, maybe grouping?
* works with pagination
* settings can be persisted in session or via database for saved searches
* works with ActiveRecord
* gets along well with will_paginate

### Possibilities:

* integrate with thinking_sphinx
* integrate with formtastic
* integrate with will_paginate
* integrate with make_resourceful

### Here is how it works:

Filterrific relies heavily on scopes. Each filter dimension has its own scope. Filterrific makes it
easy to shuttle user settings to your controllers and models for queries, and back to the views.


## Related projects

* http://github.com/plataformatec/has_scope
