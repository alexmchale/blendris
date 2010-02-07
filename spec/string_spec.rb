require File.dirname(__FILE__) + '/spec_helper.rb'

describe "redis strings" do

  it "should read and write" do
    @onion.description.should == "a tasty food"

    @onion.description = "a delicious vegetable"
    @onion.description.should == "a delicious vegetable"

    @onion.description = ""
    @onion.description.should == ""

    @onion.description = nil
    @onion.description.should == "a tasty food"

    lambda { @onion.description = 12 }.should raise_exception(TypeError)
  end

end
