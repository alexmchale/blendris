# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{blendris}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Alex McHale"]
  s.cert_chain = ["/Users/amchale/Dropbox/Security/gem-public_cert.pem"]
  s.date = %q{2010-02-11}
  s.description = %q{A redis library for Ruby}
  s.email = %q{alexmchale@gmail.com}
  s.extra_rdoc_files = ["README.rdoc", "lib/blendris.rb", "lib/blendris/accessor.rb", "lib/blendris/errors.rb", "lib/blendris/integer.rb", "lib/blendris/list.rb", "lib/blendris/model.rb", "lib/blendris/node.rb", "lib/blendris/reference.rb", "lib/blendris/reference_base.rb", "lib/blendris/reference_set.rb", "lib/blendris/set.rb", "lib/blendris/string.rb", "lib/blendris/types.rb", "lib/blendris/utils.rb", "tasks/rspec.rake"]
  s.files = ["History.txt", "Manifest", "PostInstall.txt", "README.rdoc", "Rakefile", "autotest/discover.rb", "lib/blendris.rb", "lib/blendris/accessor.rb", "lib/blendris/errors.rb", "lib/blendris/integer.rb", "lib/blendris/list.rb", "lib/blendris/model.rb", "lib/blendris/node.rb", "lib/blendris/reference.rb", "lib/blendris/reference_base.rb", "lib/blendris/reference_set.rb", "lib/blendris/set.rb", "lib/blendris/string.rb", "lib/blendris/types.rb", "lib/blendris/utils.rb", "script/console", "script/destroy", "script/generate", "spec/list_spec.rb", "spec/model_spec.rb", "spec/redis-tools_spec.rb", "spec/ref_spec.rb", "spec/set_spec.rb", "spec/spec.opts", "spec/spec_helper.rb", "spec/string_spec.rb", "tasks/rspec.rake", "blendris.gemspec"]
  s.homepage = %q{http://github.com/alexmchale/blendris}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Blendris", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{blendris}
  s.rubygems_version = %q{1.3.5}
  s.signing_key = %q{/Users/amchale/Dropbox/Security/gem-private_key.pem}
  s.summary = %q{A redis library for Ruby}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
