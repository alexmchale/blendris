require File.dirname(__FILE__) + '/spec_helper.rb'

describe "redis zsets" do

  it "should compose correctly" do
    z = RedisSortedSet.new("set1")

    z << [ [2, "timothy"], [1, "alexander"], [3, "mchale"] ]
    z.to_a.should == %w( alexander timothy mchale )

    z.set 1, "cat", 0, "dog"
    z.delete "cat"
    z.to_a.should == %w( dog )
  end

  it "should delete correctly" do
    z = RedisSortedSet.new("set1")
    z << [ [2, "timothy"], [1, "alexander"], [3, "mchale"], [0, "dog"], [7, "cat"] ]
    z.delete_by_score 1, 3
    z.to_a.should == %w( dog cat )
  end

end
