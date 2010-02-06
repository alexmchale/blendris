require 'rubygems'
gem 'hoe', '>= 2.1.0'
gem 'redis', '>= 0.1.2'
require 'hoe'
require 'fileutils'
require './lib/blendris'

Hoe.plugin :newgem

# Generate all the Rake tasks
$hoe =
  Hoe.spec 'blendris' do
    self.developer 'Alex McHale', 'alexmchale@gmail.com'
    self.post_install_message = 'PostInstall.txt'
    self.rubyforge_name       = self.name
    # self.extra_deps         = [['activesupport','>= 2.0.2']]
  end

Dir['tasks/**/*.rake'].each { |t| load t }
