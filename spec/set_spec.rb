require File.dirname(__FILE__) + '/spec_helper.rb'

describe "redis sets" do

  it "should read and write" do
    @onion.qualities.count.should == 0

    @onion.qualities << %w( delicious white weepy delicious )

    @onion.qualities.count.should == 3
    @onion.qualities.to_a.sort.should == %w( delicious weepy white )

    @onion.qualities.delete("weepy").should == true
    @onion.qualities.delete("weepy").should == false

    @onion.qualities.count.should == 2
    @onion.qualities.to_a.sort.should == %w( delicious white )
  end

  it "should allow for temporary sets" do
    extend RedisAccessor

    redis.keys("blendris:temporary:set:*").count.should == 0

    in_temporary_set do |set|
      redis.keys("blendris:temporary:set:*").count.should == 0
      set.count.should == 0
    end

    redis.keys("blendris:temporary:set:*").count.should == 0

    in_temporary_set(1, 2, 3) do |set|
      redis.keys("blendris:temporary:set:*").count.should == 1
      set.count.should == 3
    end

    redis.keys("blendris:temporary:set:*").count.should == 0
  end

  it "should do intersections properly" do
    s1 = RedisSet.new("set1")
    s2 = RedisSet.new("set2")

    s1 << [ 1, 2, 3 ]
    s2 << [ 1, 4, 5 ]

    s1.intersect!(s2).should == 1

    s1.sort.should == %w( 1 )
    s2.sort.should == %w( 1 4 5 )
  end

  it "should be able to union two sets" do
    s1 = RedisSet.new("set1")
    s2 = RedisSet.new("set2")

    s1 << %w( 1 4 5 )
    s2 << %w( 1 2 3 )

    s1.union!(s2).should == 5

    s1.sort.should == %w( 1 2 3 4 5 )
    s2.sort.should == %w( 1 2 3 )
  end

end
