module Marmalade
  class Puzzle
    attr_accessor :reader

    def initialize(file_reader, options = {})
      @options = options.dup
      @debug = (@options.delete(:debug) == true)
      self.reader = file_reader
    end

    def read(assignments, options = {})
      # TODO: Check if we're in a 'run_case' block, if so throw an error
      options = @options.merge(options)
      assigns = reader.read(assignments, options)
      assigns.each do |k, v|
        instance_variable_set("@#{k.to_s}", v)
      end
    end

    def test_cases(options = {}, &block)
      # TODO: Make sure @num_cases is set
      options = options.merge(@options)
      1.upto(@num_cases) do |case_num|
        @case_num = case_num
        instance_eval(&block)
        return if options[:case] == case_num
        STDIN.getc if options[:step]
      end
    end

    def run_case(&block)
      if @options[:case].nil? || @options[:case] == @case_num
        instance_eval(&block)
      end
    end

    def puts(*args)
      puts_with_case(*args)
    end

    def puts_dbg(*args)
      puts_with_case(*args) if @debug
    end

    private

    def puts_with_case(*args)
      print "Case ##{@case_num}: ", *args
      print "\n"
    end
  end
end
