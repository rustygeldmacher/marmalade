require 'spec_helper'

describe Marmalade::FileReader do

  context "reading strings" do
    it "will read a line from a file handle" do
      reader = build_reader("hello world")
      reader.read(:foo).should == { :foo => "hello world" }
    end

    it "will read a line and split it into an array" do
      reader = build_reader("a b c")
      reader.read(:foo, :split => true).should == { :foo => ['a', 'b', 'c'] }
    end

    it "will read multiple values from a line" do
      reader = build_reader("hello world")
      reader.read([:foo, :bar]).should == { :foo => "hello", :bar => "world" }
    end

    it "will strip whitespace from the end of the line" do
      reader = build_reader("\thello world   ")
      reader.read(:foo).should == { :foo => "hello world" }
    end

    it "will read an empty line as an empty string" do
      reader = build_reader(nil)
      reader.read(:empty).should == { :empty => "" }
    end
  end

  context "reading integers" do
    it "will read an integer value from a file" do
      reader = build_reader("9")
      reader.read(:foo, :type => :int).should == { :foo => 9 }
    end

    it "will read multiple integer values from a line" do
      reader = build_reader("15 22")
      reader.read([:foo, :bar], :type => :int).should == { :foo => 15, :bar => 22 }
    end

    it "will read an array of integers from a line" do
      reader = build_reader("1 2 3")
      reader.read(:foo, :type => :int, :split => true).should == { :foo => [1, 2, 3] }
    end
  end

  context "reading multiple lines" do
    it "will read multiple lines into a value" do
      reader = build_reader('a b', 'c d', 'e f')
      reader.read(:foo, :count => 3).should == { :foo => ['a b', 'c d', 'e f'] }
    end

    it "will read multiple values and split them into arrays" do
      reader = build_reader('a b', 'c', 'd e')
      reader.read(:foo, :count => 3, :split => true).should == { :foo => [['a', 'b'], ['c'], ['d', 'e']] }
    end

    it "will read multiple lines of integers" do
      reader = build_reader('1', '2', '3')
      reader.read(:foo, :count => 3, :type => :int).should == { :foo => [1, 2, 3] }
    end

    it "will return an array of lines even if asking for one line" do
      reader = build_reader('abc')
      reader.read(:foo, :count => 1).should == { :foo => ['abc'] }
    end
  end

  def build_reader(*lines)
    seq = sequence('file_handle')
    file_handle = mock('file_handle')
    lines.each do |line|
      file_handle.expects(:gets).in_sequence(seq).returns(line)
    end
    Marmalade::FileReader.new(file_handle)
  end

end
