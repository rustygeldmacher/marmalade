require 'spec_helper'

describe TestCase do

  before do
    @test_case = TestCase.new(4)
  end

  describe '#initialize' do
    it 'sets the case_num' do
      @test_case.case_num.should == 4
    end
  end

  describe "#puts" do
    it 'will print the message along with the current case number to STDOUT' do
      STDOUT.expects(:print).with("Case #4: hello\n")
      @test_case.puts("hello")
    end
    it 'will print to the supplied IO buffer if an output option is given' do
      output = mock()
      output.expects(:print).with("Case #4: hello\n")
      @test_case.output = output
      @test_case.puts("hello")
    end
  end

  describe "#puts_dbg" do
    it "will print the message with the case number if in debug mode" do
      @test_case.debug = true
      STDOUT.expects(:print).with("Case #4: hello\n")
      @test_case.puts_dbg('hello')
    end

    it "will not print the message if the @test_case isn't in debug mode" do
      @test_case.debug = false
      STDOUT.expects(:print).never
      @test_case.puts_dbg('hello')
    end

    it "will run and print the value of a block if one is given" do
      @test_case.debug = true
      STDOUT.expects(:print).with("Case #4: hello\n")
      @test_case.puts_dbg do
        v = 'h'
        v += 'ello'
      end
    end

    it "will not run and print the value of a block if debug is false" do
      @test_case.debug = false
      STDOUT.expects(:print).never
      count = 1
      @test_case.puts_dbg do
        count = 9
        'hello'
      end
      count.should == 1
    end
  end

end
