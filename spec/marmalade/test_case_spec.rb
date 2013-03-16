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
    it 'will print the message along with the current case number' do
      @test_case.expects(:print).with("Case #4: ")
      @test_case.expects(:print).with("hello")
      @test_case.expects(:print).with("\n")
      @test_case.puts("hello")
    end
  end

  describe "#puts_dbg" do
    it "will print the message with the case number if in debug mode" do
      @test_case.debug = true
      @test_case.expects(:print).with("Case #4: ")
      @test_case.expects(:print).with("hello")
      @test_case.expects(:print).with("\n")
      @test_case.puts_dbg('hello')
    end

    it "will not print the message if the @test_case isn't in debug mode" do
      @test_case.debug = false
      @test_case.expects(:print).never
      @test_case.puts_dbg('hello')
    end
  end


end
