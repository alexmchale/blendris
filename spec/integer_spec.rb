require File.dirname(__FILE__) + '/spec_helper.rb'

describe "redis integers" do

  it "should always be an integer" do
    @onion.calories.should == 0
    @onion.calories = 450
    @onion.calories.should == 450
    @onion[:calories].increment.should == 451
    @onion.calories.should == 451
    @onion[:calories].decrement.should == 450
    @onion.calories.should == 450
  end

end
