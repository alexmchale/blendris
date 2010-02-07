begin
  require 'spec'
rescue LoadError
  require 'rubygems' unless ENV['NO_RUBYGEMS']
  gem 'rspec'
  require 'spec'
end

$:.unshift(File.dirname(__FILE__) + '/../lib')
require 'blendris'

include Blendris

module TestFixtures

  class Food < Model

    key "food", :name

    string  :name
    string  :description, :default => "a tasty food"
    integer :calories, :default => 0
    set     :qualities
    list    :sales
    ref     :category, :class => "TestFixtures::Category", :reverse => :foods
    ref     :sibling, :class => Food, :reverse => :sibling
    refs    :friends, :class => Food, :reverse => :friends
    ref     :something

  end

  class Category < Model

    key "category", :name

    string :name
    refs   :foods, :class => "TestFixtures::Food", :reverse => :category

  end

  class FavoriteFood < Model

    key "person", :person, :food

    string :person
    ref    :food, :class => Food

  end

end

Spec::Runner.configure do |config|
  config.before(:each) do
    extend RedisAccessor
    extend TestFixtures

    RedisAccessor.prefix = "blendris-spec:"
    RedisAccessor.flush_keys

    @vegetable = Category.create("vegetable")
    @onion = Food.create("onion")
    @beans = Food.create("beans")

    @fruit = Category.create("fruit")
    @apple = Food.create("apple")
    @lemon = Food.create("lemon")

    @meat = Category.create("meat")
    @steak = Food.create("steak")
  end

  config.after(:each) do
    RedisAccessor.flush_keys
  end
end

