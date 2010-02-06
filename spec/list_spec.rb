require File.dirname(__FILE__) + '/spec_helper.rb'

describe "redis lists" do

  it "should read and write" do
    @onion.sales.count.should == 0

    @onion.sales << %w( to-bill to-tom to-bill to-bob to-tom )
    @onion.sales.count.should == 5
    @onion.sales.to_a.should == %w( to-bill to-tom to-bill to-bob to-tom )

    @onion.sales.delete("to-bill").should == 2
    @onion.sales.delete("to-bob").should == 1
    @onion.sales.to_a.should == %w( to-tom to-tom )
  end

end
