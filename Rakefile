require "rubygems"
require "rubygems/commands/push_command"
require "rspec/core/rake_task"

require "echoe"
require "redis"
require "fileutils"
require "./lib/blendris"

Echoe.new("blendris", Blendris::VERSION) do |p|

  p.description              = "A redis library for Ruby"
  p.url                      = "http://github.com/alexmchale/blendris"
  p.author                   = "Alex McHale"
  p.email                    = "alexmchale@gmail.com"
  p.ignore_pattern           = [ "tmp", "pkg", "script" ]
  p.development_dependencies = []
  p.runtime_dependencies     = [ "redis >=2.0.13" ]

end

RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = "spec/**/*_spec.rb"
end

Dir['tasks/**/*.rake'].each { |t| load t }
