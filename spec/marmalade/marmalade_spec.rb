require 'spec_helper'

describe Marmalade do

  it "will coordinate opening and reading a file full of test cases" do
    cases = {}
    Marmalade.jam(:file => fixture_file('input_0.txt')) do
      read :num_cases, :type => :int
      test_cases do
        read [:dummy, :n], :type => :int
        read :lines, :count => @n
        run_case do
          cases[@case_num] = { :dummy => @dummy, :lines => @lines }
        end
      end
    end
    cases.should == { 1 => { :dummy => 1, :lines => ['foo', 'bar'] },
                      2 => { :dummy => 9, :lines => ['a', 'b', 'c', 'd'] },
                      3 => { :dummy => 3, :lines => ['hello world'] } }
  end

  it "will throw an error if the input file does not exist" do
    Marmalade.expects(:puts).with("** Error: Cannot find input file nothing.txt")
    ran = false
    Marmalade.jam(:file => 'nothing.txt') { ran = true }
    ran.should be_false
  end
end
