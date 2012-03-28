require 'spec_helper'

describe Marmalade::Puzzle do

  describe "#read" do
    it "will pass the options to the reader and assign instance varialbes based on the results" do
      reader = mock()
      reader.expects(:read).with([:foo, :bar], { :a => 1, :b => 2}).returns({:foo => "a", :bar => 2})
      puzzle = Marmalade::Puzzle.new(reader, :a => 1)
      puzzle.read([:foo, :bar], :b => 2)
      puzzle.instance_eval do
        @foo.should == 'a'
        @bar.should == 2
      end
    end
  end

  describe "#test_cases" do
    it "will run through all the test cases" do
      run_test_cases.should == [1, 2, 3]
    end

    it "will return after the specified case as part of support for run_case" do
      run_test_cases(:case => 2).should == [1, 2]
    end

    it "will pause after each case if the :step option is set" do
      STDIN.expects(:getc).times(3)
      run_test_cases(:step => true)
    end

    def run_test_cases(options = {})
      puzzle = Marmalade::Puzzle.new(mock('reader'))
      puzzle.instance_eval do
        @num_cases = 3
      end
      case_numbers = []
      puzzle.test_cases(options) do
        case_numbers << @case_num
      end
      case_numbers
    end
  end

  describe "#run_case" do
    before do
      @puzzle = Marmalade::Puzzle.new(mock('file_reader'))
    end

    it "will evaluate the given block if no case options are specified" do
      build_puzzle(3).run_case do
        'foo'
      end.should == 'foo'
    end

    it "will evaluate the block if the given case and the current case match" do
      build_puzzle(3, :case => 3).run_case do
        'foo'
      end.should == 'foo'
    end

    it "will not evalulate the block if the case numbers don't match" do
      build_puzzle(3, :case => 4).run_case do
        'foo'
      end.should be_nil
    end
  end

  describe "#puts" do
    it "will print the message along with the current case number" do
      puzzle = build_puzzle(4)
      puzzle.expects(:print).with("Case #4: ", "hello")
      puzzle.expects(:print).with("\n")
      puzzle.puts("hello")
    end
  end

  describe "#puts_dbg" do
    it "will print the message with the case number if in debug mode" do
      puzzle = build_puzzle(4, :debug => true)
      puzzle.expects(:print).with("Case #4: ", "hello")
      puzzle.expects(:print).with("\n")
      puzzle.puts_dbg('hello')
    end

    it "will not print the message if the puzzle isn't in debug mode" do
      puzzle = build_puzzle(4)
      puzzle.expects(:print).never
      puzzle.puts_dbg('hello')
    end
  end

  def build_puzzle(case_num, options = {})
    puzzle = Marmalade::Puzzle.new(mock('file_reader'), options)
    puzzle.instance_eval do
      @case_num = case_num
    end
    puzzle
  end

end