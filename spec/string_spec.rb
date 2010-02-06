require File.dirname(__FILE__) + '/spec_helper.rb'

describe "redis strings" do

  it "should read and write" do
    @onion.description.should == nil

    @onion.description = "a delicious vegetable"
    @onion.description.should == "a delicious vegetable"

    @onion.description = ""
    @onion.description.should == ""

    @onion.description = nil
    @onion.description.should == nil
  end

end
