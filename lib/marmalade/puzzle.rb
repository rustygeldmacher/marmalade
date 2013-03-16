# TODO: RDoc this
require 'parallel'

module Marmalade
  class Puzzle
    attr_accessor :reader

    def initialize(file_reader, options = {})
      @options = options.dup
      @debug = (@options.delete(:debug) == true)
      self.reader = file_reader
    end

    def read_num_cases
      read :num_cases, :type => :int
    end

    def read(assignments, options = {})
      assigns = reader.read(assignments, options)
      assigns.each do |k, v|
        # Set an ivar on both the puzzle and the test case so we can support using them in
        # subsequent calls to 'read' in the same block evaluation.
        instance_variable_set("@#{k.to_s}", v)
        if @current_case
          @current_case.instance_variable_set("@#{k.to_s}", v)
        end
      end
    end

    def test_cases(options = {}, &block)
      unless @num_cases.is_a?(Fixnum)
        raise MarmaladeError.new("@num_cases has not been set or is not an integer")
      end
      options = options.merge(@options)
      1.upto(@num_cases).each do |case_num|

        test_case = TestCase.new(case_num, options)
        test_case.debug = @debug

        @current_case = test_case
        instance_eval(&block)
        @current_case = nil

        if options[:case].nil? || options[:case] == case_num
          test_case.run
          if options[:step] == true
            STDIN.getc if options[:step]
          end
        end
      end
    end

    def run_case(&block)
      @current_case.run_block = block
    end

  end
end
