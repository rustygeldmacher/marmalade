require 'parallel'

module Marmalade
  class Puzzle
    attr_accessor :reader

    def initialize(file_reader, options = {})
      self.reader = file_reader
      @options = options.dup
      @debug = (@options[:debug] == true)
      if @options[:processes].to_i > 1 && !@options[:parallel]
        @options[:parallel] = true
      end
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

      # Set up all test cases and read each one's info from the file
      test_cases = []
      1.upto(@num_cases).each do |case_num|
        test_case = TestCase.new(case_num, options)
        test_case.debug = @debug

        @current_case = test_case
        instance_eval(&block)
        @current_case = nil

        test_cases << test_case
      end

      # If we are to run in more than one process, we'll run all of the tests without
      # regard to stepping or finding a single case to run
      if options[:parallel]
        # Setup pipes for the output of each test case
        reader, writer = IO.pipe
        test_cases.each do |test_case|
          test_case.output = writer
        end
        # Run them
        processes = options[:processes] || Parallel.processor_count
        Parallel.each(test_cases, :in_processes => processes) do |test_case|
          test_case.run
        end
        # Now output the buffers from each case
        writer.close
        outputs = []
        # TODO: This could probably be done with a stable sort instead...
        while message = reader.gets
          match = message.match(/Case #(\d+)/)
          if match
            case_num = match[1].to_i
            case_output = outputs[case_num] ||= []
            case_output << message
          else
            outputs << message
          end
        end
        outputs.flatten.compact.each { |msg| puts msg }
      else
        test_cases.each do |test_case|
          if options[:case].nil? || options[:case] == test_case.case_num
            test_case.run
            if options[:step] == true
              STDIN.getc if options[:step]
            end
          end
        end
      end
    end

    def run_case(&block)
      @current_case.run_block = block
    end

  end
end
