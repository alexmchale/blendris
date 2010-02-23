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

Key sets the base key for this object.

* Any strings in the key will be used as literal strings.
* Any symbols in the key will be set to the value of that field in this object.
* In the case of the employer "37 Signals" it would create a key
  "employer:37_Signals" and set its value to "Employer".
* Note that spaces are converted to underscores, as spaces are not allowed in
  Redis keys.  This could cause problems in some data sets.
* Also note that the value assigned to the base key is the class name of the
  model being used.
* Only strings and integers should be used as key values.

    # Create a new Employer named "37 Signals"
    >> employer = Employer.create("37 Signals")
    => #<Employer:0x169da74 @key="employer:37_Signals">

    >> employer.key
    => "employer:37_Signals"

    >> employer.name
    => "37 Signals"

    >> employer[:name]
    => #<Blendris::RedisString:0x20dbd794 @key="employer:37_Signals:name", ...>

    >> employer[:name].key
    => "employer:37_Signals:name"

### string ###

String creates a string key named for the first parameter given to it.
This means that it would generate a key "employer:37_Signals:name" with
a value of "37 Signals".

### ref and refs ###

Refs maintain references to other objects.

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

Calling *create* on an object key that already exists is perfectly acceptable
and only results in new Ruby objects being instantiated.  They will all read
and write to the same Redis data.  Calling *new* however must be done on a
Redis key that already exists and is set to the name of the requested model.

    >> Employer.create("Giant Faceless Corporation")
    => #<Employer:0x45a84b38 @key="employer:Giant_Faceless_Corporation">

    >> Employer.create("Giant Faceless Corporation")
    => #<Employer:0x12b8501d @key="employer:Giant_Faceless_Corporation">

    >> Employer.create("Giant Faceless Corporation")
    => #<Employer:0x742136c6 @key="employer:Giant_Faceless_Corporation">

    >> Employer.new("Anything")
    TypeError: Anything does not exist, not a Employer - you may want create instead of new
            from .../blendris/lib/blendris/model.rb:25:in `initialize'
            from (irb):32:in `new'
            from (irb):32

    >> Employer.new("employer:Giant_Faceless_Corporation")
    => #<Employer:0x73cb4cae @key="employer:Giant_Faceless_Corporation">

    >> Employee.create("Invisible Woman")
    => #<Employee:0x5f27a49c @key="employee:Invisible_Woman">

    >> Employer.new("employee:Invisible_Woman")
    TypeError: employee:Invisible_Woman is a Employee, not a Employer
            from /Users/amchale/Dropbox/Projects/blendris/lib/blendris/model.rb:26:in `initialize'
            from (irb):36:in `new'
            from (irb):36

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
