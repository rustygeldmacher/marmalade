require 'spec_helper'

describe Marmalade::Puzzle do

  describe '#read' do
    before do
      @reader = mock()
      @puzzle = Marmalade::Puzzle.new(@reader)
    end
    it "assigns instance variables based on the results from the file reader" do
      @reader.expects(:read).with([:foo, :bar], { :a => 1 }).returns({:foo => "a", :bar => 2})
      @puzzle.read([:foo, :bar], :a => 1)
      @puzzle.instance_eval do
        @foo.should == 'a'
        @bar.should == 2
      end
    end
    it 'assigns the instance variables to the current test case if there is one' do
      @reader.expects(:read).with([:foo, :bar], { :a => 1 }).returns({:foo => "a", :bar => 2})
      current_case = Object.new
      @puzzle.instance_variable_set('@current_case', current_case)
      @puzzle.read([:foo, :bar], :a => 1)
      current_case.instance_eval do
        @foo.should == 'a'
        @bar.should == 2
      end
    end
  end

  describe '#read_num_cases' do
    before do
      @reader = mock()
      @puzzle = Marmalade::Puzzle.new(@reader)
    end
    it "will use the reader to read in the number of cases" do
      @reader.expects(:read).with(:num_cases, :type => :int).returns({:num_cases => 1234})
      @puzzle.read_num_cases
      @puzzle.instance_eval do
        @num_cases.should == 1234
      end
    end
  end

  describe "test_cases and run_case blocks" do
    before do
      @reader = mock('reader')
      @puzzle = Marmalade::Puzzle.new(@reader)
      @puzzle.instance_eval do
        @num_cases = 3
      end
    end

    it 'sets the options for each TestCase base on its own options' do
      values = []
      @puzzle.test_cases :opt1 => :foo, :opt2 => 'bar' do
        run_case do
          values << @options
        end
      end
      values.each do |options|
        options.should == {:opt1 => :foo, :opt2 => 'bar'}
      end
    end

    it 'sets the case_num for each TestCase' do
      values = []
      @puzzle.test_cases do
        run_case do
          values << case_num
        end
      end
      values.should == [1, 2, 3]
    end

    it 'sets the debug flag for each test case if debug is set' do
      @puzzle.instance_eval do
        @debug = true
      end
      values = []
      @puzzle.test_cases do
        run_case do
          values << debug
        end
      end
      values.should == [true, true, true]
    end

    it 'sets test case instance variables based on what is read from the file' do
      @reader.expects(:read).with(:foo, {}).times(3).
        returns({:foo => :a}, {:foo => :b}, {:foo => :c})
      values = []
      @puzzle.test_cases do
        read :foo
        run_case do
          values << @foo
        end
      end
      values.should == [:a, :b, :c]
    end

    it 'only runs the given case if the :case option is set' do
      values = []
      @puzzle.test_cases :case => 2 do
        run_case do
          values << case_num
        end
      end
      values.should == [2]
    end

    it "pauses after each case if the :step option is set" do
      STDIN.expects(:getc).times(3)
      @puzzle.test_cases :step => true do
        run_case do
        end
      end
    end

    it "raises an error if num_cases hasn't been set" do
      @puzzle.instance_eval { @num_cases = nil }
      expect do
        @puzzle.test_cases do
          puts "this won't get called."
        end
      end.to raise_error(MarmaladeError, /has not been set/)
    end

    context 'when the parallel option is set' do
      it 'runs the cases in parallel and prints the output in order' do
        sleep_times = [0.75, 0.25, 0.5]
        test_output = sequence('test_output')
        @puzzle.expects(:puts).with("Case #1: hello\n").in_sequence(test_output)
        @puzzle.expects(:puts).with("Case #2: hello\n").in_sequence(test_output)
        @puzzle.expects(:puts).with("Case #3: hello\n").in_sequence(test_output)
        @puzzle.test_cases :parallel => true do
          run_case do
            sleep sleep_times[case_num - 1]
            puts "hello"
          end
        end
      end
    end

  end

end