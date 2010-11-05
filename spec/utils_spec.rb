require File.dirname(__FILE__) + '/spec_helper.rb'

describe "utility methods" do

  include Blendris::Utils

  it "should pairify an array" do
    pairify(nil).should == []
    pairify([]).should == []
    pairify(1).should == []
    pairify(1, 2).should == [ [1, 2] ]
    pairify(1, 2, 3, [4, 5], 6, 7).should == [ [1, 2], [3, 4], [5, 6] ]
  end

end
