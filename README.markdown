# Blendris #

* http://github.com/alexmchale/blendris



# DESCRIPTION #

Blendris is a Ruby interface to a Redis database.



# FEATURES/PROBLEMS #

BLENDRIS IS IN VERY EARLY ALPHA!!!

PLEASE DON'T USE IT FOR ANYTHING IMPORTANT YET!!!



# SYNOPSIS #



# REQUIREMENTS #

* Blendris uses the redis RubyGem.



# INSTALL #

* gem install blendris



# EXAMPLES #

The following would create a Website model that knows its url and
paths within the website.

  class Website < Blendris::Model
    key "website", :title

    string :title
    string :url
    set    :paths
  end

  website = Website.create("One Fake Website")
  website.url = "http://fakewebsite.com"
  website.paths << "/blog/index"
  website.paths << "/admin/index"

The above would create the following Redis keys:

  website:One_Fake_Website       => "Website" (This identifies the model type)
  website:One_Fake_Website:name  => "One Fake Website"
  website:One_Fake_Website:url   => "http://fakewebsite.com"
  website:One_Fake_Website:paths => [ "/blog/index", "/admin/index" ]

Now suppose we want to open the Website model back up to add a concept of sister sites:

  class Website
    refs :sister_sites, :class => Website, :reverse => :sister_sites
  end

This will cause the website to maintain a set of other websites.  The reverse tag
causes the other website's sister_sites set to be updated when it is added or removed
from this site's list.



# LICENSE #

(The MIT License)

Copyright (c) 2010 Alexander Timothy McHale

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
