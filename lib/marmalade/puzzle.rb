# TODO: RDoc this
# TODO: read_array
# TODO: read_integer_array
# TODO: read_values

module Marmalade
  class Puzzle
    attr_accessor :reader

    def initialize(file_reader, options = {})
      @options = options.dup
      @debug = (@options.delete(:debug) == true)
      self.reader = file_reader
    end

    def read(assignments, options = {})
      if @running_case
        raise MarmaladeError.new("Cannot call read while in a run_case block")
      end
      options = @options.merge(options)
      assigns = reader.read(assignments, options)
      assigns.each do |k, v|
        instance_variable_set("@#{k.to_s}", v)
      end
    end

    def read_num_cases
      read :num_cases, :type => :int
    end

    def test_cases(options = {}, &block)
      unless @num_cases.is_a?(Fixnum)
        raise MarmaladeError.new("@num_cases has not been set or is not an integer")
      end
      options = options.merge(@options)
      1.upto(@num_cases) do |case_num|
        @case_num = case_num
        instance_eval(&block)
        return if options[:case] == case_num
        STDIN.getc if options[:step]
      end
    end

    def run_case(&block)
      @running_case = true
      if @options[:case].nil? || @options[:case] == @case_num
        instance_eval(&block)
      end
      @running_case = false
    end

    def puts(*args)
      puts_with_case(*args)
    end

    def puts_dbg(*args)
      puts_with_case(*args) if @debug
    end

    private

    def puts_with_case(*args)
      unless @case_num.nil?
        print "Case ##{@case_num}: "
      end
      print *args
      print "\n"
    end
  end
end
