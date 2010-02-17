require File.dirname(__FILE__) + '/spec_helper.rb'

describe Model do

  it "should have valid keys" do
    @onion.key.should == "food:onion"
    @onion.name.should == "onion"
  end

  it "should have a working integer field" do
    @onion.calories.should == 0

    @onion.calories = 120
    @onion.calories.should == 120
  end

  it "should have a valid reference" do
    @onion.category.should be_nil

    @onion.category = @vegetable
    @onion.category.name.should == "vegetable"
  end

  it "should not allow its key values to be changed" do
    lambda { @onion.name = "asdf" }.should raise_exception(BlendrisCannotSetKeyValue)
    lambda { @onion.description = "asdf" }.should_not raise_exception
  end

  it "should have a valid reference set" do
    @fruit.foods.count.should == 0

    @fruit.foods << [ @apple, @lemon ]

    @fruit.foods.should be_include(@apple)
    @fruit.foods.should be_include(@lemon)
    @fruit.foods.should be_include(Food.new("food:lemon"))
    @fruit.foods.should_not be_include(@steak)
  end

  it "should not allow you to instantiate with a key that doesnt match its class" do
    lambda { Category.new("balogna") }.should raise_error(TypeError)
    lambda { Category.new(@onion.key) }.should raise_error(TypeError)
    lambda { Category.new(@vegetable.key) }.should_not raise_error(TypeError)
  end

  it "should allow for complex types in the key" do
    lambda { FavoriteFood.create("Billy Bob Thorton", "squeezy") }.should raise_error(TypeError)

    fav = FavoriteFood.create("Billy Bob Thorton", @onion)

    fav.key.should == "person:Billy_Bob_Thorton:food:onion"
    fav.person.should == "Billy Bob Thorton"
    fav.food.should == @onion
  end

  it "should have a valid list of fields" do

    fields = %w( name foods )

    @vegetable.fields.should == fields

  end

  it "should use its on_change field correctly" do
    @apple.calories.should == 0
    @apple.description = "good"
    @apple.description = "bad"
    @apple.calories.should == 2
  end

  context "with single reference" do

    it "should reverse to a single reference" do
      @apple.sibling.should be_nil
      @lemon.sibling.should be_nil

      @apple.sibling = @lemon

      @apple.sibling.should == @lemon
      @lemon.sibling.should == @apple

      @lemon.sibling = nil

      @apple.sibling.should be_nil
      @lemon.sibling.should be_nil
    end

    it "should reverse to a reference set" do
      @onion.category.should be_nil
      @vegetable.foods.count.should be_zero

      2.times do
        @onion.category = @vegetable

        @onion.category.name.should == "vegetable"
        @vegetable.foods.count.should == 1
        @vegetable.foods.should be_include(@onion)
      end

      @onion.category = nil

      @onion.category.should be_nil
      @vegetable.foods.count.should == 0
      @vegetable.foods.should_not be_include(@onion)
    end

    it "should allow for generic references" do
      @onion.something.should be_nil

      @onion.something = @steak
      @onion.something.name.should == "steak"

      @onion.something = @vegetable
      @onion.something.name.should == "vegetable"
    end

  end

  context "with reference sets" do

    it "should reverse to single references" do
      @onion.category.should be_nil
      @vegetable.foods.count.should be_zero

      2.times do
        @vegetable.foods << @onion

        @onion.category.name.should == "vegetable"
        @vegetable.foods.count.should == 1
        @vegetable.foods.should be_include(@onion)
      end

      @vegetable.foods.delete @onion

      @onion.category.should be_nil
      @vegetable.foods.count.should == 0
      @vegetable.foods.should_not be_include(@onion)
    end

    it "should reverse to a reference set" do
      @apple.friends.count.should == 0
      @lemon.friends.count.should == 0
      @onion.friends.count.should == 0

      @apple.friends << [ @lemon, @onion ]

      @apple.friends.count.should == 2
      @lemon.friends.count.should == 1
      @onion.friends.count.should == 1

      @apple.friends.should be_include(@lemon)
      @apple.friends.should be_include(@onion)
      @lemon.friends.should be_include(@apple)
      @onion.friends.should be_include(@apple)

      @apple.friends.delete @lemon

      @apple.friends.count.should == 1
      @lemon.friends.count.should == 0
      @onion.friends.count.should == 1

      @apple.friends.should_not be_include(@lemon)
      @apple.friends.should be_include(@onion)
      @lemon.friends.should_not be_include(@apple)
      @onion.friends.should be_include(@apple)
    end

  end

  context "website sister sites" do

    it "should update each others sister sites table" do

      site1 = Website.create("Site One")
      site2 = Website.create("Site Two")

      site1.sister_sites.count.should == 0
      site2.sister_sites.count.should == 0
      site1.sister_sites.should_not be_include site2
      site2.sister_sites.should_not be_include site1

      site1.sister_sites << site2

      site1.sister_sites.count.should == 1
      site2.sister_sites.count.should == 1
      site1.sister_sites.should be_include site2
      site2.sister_sites.should be_include site1

      site2.sister_sites.delete site1

      site1.sister_sites.count.should == 0
      site2.sister_sites.count.should == 0
      site1.sister_sites.should_not be_include site2
      site2.sister_sites.should_not be_include site1

    end

  end

  it "should enumerable all foods" do
    Food.count.should == 5

    count = 0

    Food.each do |food|
      count += 1
      food.should be_a(Food)
    end

    count.should == 5
  end

  it "should call its on_change method for all fields" do
    o = OnChangeTestModel.create
    lambda { o.string = "test" }.should raise_exception TestEx
    lambda { o.integer = 123 }.should raise_exception TestEx
    lambda { o.set = [1,2,3] }.should raise_exception TestEx
    lambda { o.list = [1,5,8] }.should raise_exception TestEx
    lambda { o.ref = o }.should raise_exception TestEx
    lambda { o.refs << o }.should raise_exception TestEx
  end

end
