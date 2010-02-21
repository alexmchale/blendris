require "rubygems"

gem "echoe", ">= 4.1"
gem "redis", ">= 0.1.2"

require "echoe"

require "redis"
require "fileutils"
require "./lib/blendris"

Echoe.new("blendris", "0.5") do |p|

  p.description              = "A redis library for Ruby"
  p.url                      = "http://github.com/alexmchale/blendris"
  p.author                   = "Alex McHale"
  p.email                    = "alexmchale@gmail.com"
  p.ignore_pattern           = [ "tmp", "pkg", "script" ]
  p.development_dependencies = []

end

Dir['tasks/**/*.rake'].each { |t| load t }
