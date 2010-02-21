require File.dirname(__FILE__) + '/spec_helper.rb'

describe "redis connection accessor" do

  it "should connect for reading and writing" do
    extend RedisAccessor

    testkey = "test-string"

    redis.get(testkey).should == nil
    redis.set(testkey, "foo").should == true
    redis.get(testkey).should == "foo"
    redis.del(testkey).should == true
    redis.del(testkey).should == false
  end

  it "should allow for keys to be renamed" do
    s = RedisString.new("string1")
    s.set "hobo"

    s.rename "string2"
    s.key.should == "string2"
    s.get.should == "hobo"

    RedisString.new("string1").get.should be_nil
    RedisString.new("string2").get.should == "hobo"
  end

end
