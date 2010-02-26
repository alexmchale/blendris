require File.dirname(__FILE__) + '/spec_helper.rb'

describe "references" do

  it "should handle complex transitions" do

    @vegetable.foods.count.should == 0
    @fruit.foods.count.should == 0
    @onion.category.should be_nil

    @vegetable.foods << @onion

    @vegetable.foods.count.should == 1
    @vegetable.foods.first.should == @onion
    @fruit.foods.count.should == 0
    @onion.category.should == @vegetable

    @fruit.foods << @onion

    @vegetable.foods.count.should == 0
    @fruit.foods.count.should == 1
    @fruit.foods.first.should == @onion
    @onion.category.should == @fruit

    @onion.category = nil

    @vegetable.foods.count.should == 0
    @fruit.foods.count.should == 0
    @onion.category.should be_nil

    @onion.category = @vegetable

    @vegetable.foods.count.should == 1
    @vegetable.foods.first.should == @onion
    @fruit.foods.count.should == 0
    @onion.category.should == @vegetable

    @vegetable.foods = [ @apple, @lemon, @lemon ]
    @vegetable.foods << @apple
    @vegetable.foods.count.should == 2
    @vegetable.foods.should be_include @apple
    @vegetable.foods.should be_include @lemon
    @apple.category.should == @vegetable
    @lemon.category.should == @vegetable
    @onion.category.should == nil

  end

end
