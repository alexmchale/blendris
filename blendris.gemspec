# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{blendris}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Alex McHale"]
  s.date = %q{2010-02-06}
  s.description = %q{Blendris is a Ruby interface to a Redis database.}
  s.email = ["alexmchale@gmail.com"]
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "PostInstall.txt"]
  s.files = ["History.txt", "Manifest.txt", "PostInstall.txt", "README.rdoc", "Rakefile", "blendris.gemspec", "lib/blendris.rb", "lib/blendris/accessor.rb", "lib/blendris/errors.rb", "lib/blendris/list.rb", "lib/blendris/model.rb", "lib/blendris/node.rb", "lib/blendris/reference.rb", "lib/blendris/reference_base.rb", "lib/blendris/reference_set.rb", "lib/blendris/set.rb", "lib/blendris/string.rb", "lib/blendris/utils.rb", "script/console", "script/destroy", "script/generate", "spec/list_spec.rb", "spec/model_spec.rb", "spec/redis-tools_spec.rb", "spec/set_spec.rb", "spec/spec.opts", "spec/spec_helper.rb", "spec/string_spec.rb", "tasks/rspec.rake"]
  s.homepage = %q{http://github.com/alexmchale/blendris}
  s.post_install_message = %q{PostInstall.txt}
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{blendris}
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Blendris is a Ruby interface to a Redis database.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rubyforge>, [">= 2.0.3"])
      s.add_development_dependency(%q<gemcutter>, [">= 0.3.0"])
      s.add_development_dependency(%q<hoe>, [">= 2.5.0"])
    else
      s.add_dependency(%q<rubyforge>, [">= 2.0.3"])
      s.add_dependency(%q<gemcutter>, [">= 0.3.0"])
      s.add_dependency(%q<hoe>, [">= 2.5.0"])
    end
  else
    s.add_dependency(%q<rubyforge>, [">= 2.0.3"])
    s.add_dependency(%q<gemcutter>, [">= 0.3.0"])
    s.add_dependency(%q<hoe>, [">= 2.5.0"])
  end
end
