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

end
