# Blendris #

http://github.com/alexmchale/blendris



# DESCRIPTION #

Blendris is a Ruby interface to a Redis database.  It performs no caching,
causing all reads and writes to interact directly with Redis.



# FEATURES/PROBLEMS #

BLENDRIS IS IN VERY EARLY ALPHA!!!

PLEASE DON'T USE IT FOR ANYTHING IMPORTANT YET!!!

Blendris provides a way to create an object hierarchy within Redis,
a key-value database.  It provides very little in the way of indexing
or querying that data.  It is up to the user to maintain objects
representing the query in which they are interested.



# REQUIREMENTS #

Blendris uses the [redis](http://gemcutter.org/gems/redis) gem.



# INSTALL #

gem install blendris



# EXAMPLES #

Let's say we want to maintain a list of employers and employees.

    class Employer < Blendris::Model
      key "employer", :name

      string :name
      string :address

      refs :employees, :class => "Employee", :reverse => :employer
    end

    class Employee < Blendris::Model
      key "employee", :name

      string :name
      string :address
      set :family_members

      ref :employer, :class => "Employer", :reverse => :employees
    end

And now some examples of using them:

    >> captain = Employee.create("Captain Amazing")
    => #<Employee:0x45d18084 @key="employee:Captain_Amazing">

    >> captain.address = "123 Fake Street"
    => "123 Fake Street"

    >> guild = Employer.create("The Really Fantastic Guild of Heroes")
    => #<Employer:0x476e46f5 @key="employer:The_Really_Fantastic_Guild_of_Heroes">

    >> guild.employees << captain
    => #<Blendris::RedisReferenceSet:0x500150a0 @key="employer:The_Really_Fantastic_Guild_of_Heroes:employees", ...>

    >> guild.employees.first.address
    => "123 Fake Street"

    >> guild.employees.count
    => 1

    >> guild.employees.first.employer.employees.first.name
    => "Captain Amazing"

### key ###

Key sets the base key for this object.  In the case of the employer
"37 Signals" it would create a key "employer:37_Signals" and set its value
to "Employer".  In the key, strings are interpreted as literals and
symbols are interpreted as pointers to that data field.

* Note that spaces are converted to underscores, as spaces are not
  allowed in Redis keys.  This could cause problems in some data sets.
* Also note that the value assigned to the base key is the class name of
  the model being used.
* Only strings and integers should be used as key values.

### string ###

String creates a string key named for the first parameter given to it.
This means that it would generate a key "employer:37_Signals:name" with
a value of "37 Signals".

### refs ###

Refs maintains a set of references to other objects.

* *:class* will limit objects in this reference set to the given class.
  If a string is specified as a class, it will be constantized before
  comparing.
* *:reverse* will cause the given field to be updated on the object when
  it is added to or removed from this set.

### new vs create ###

Calling the *create* method will build a new object, generating a new base
key based upon the parameters.  The parameter list should be the same as
the list of symbols in your *key* field.

Calling the *new* method will instantiate an existing object using the
given *key* as the base key.



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
