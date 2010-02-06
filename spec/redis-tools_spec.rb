require File.dirname(__FILE__) + '/spec_helper.rb'

describe "redis connection accessor" do

  it "should connect for reading and writing" do
    testkey = prefix + "test-string"

    redis.get(testkey).should == nil
    redis.set(testkey, "foo").should == true
    redis.get(testkey).should == "foo"
    redis.del(testkey).should == true
    redis.del(testkey).should == false
  end

end
