class TestCase
  attr_accessor :case_num
  attr_accessor :debug
  attr_accessor :run_block

  def initialize(case_num, options = {})
    self.case_num = case_num
    @output = options[:output] || STDOUT
    @options = options
  end

  def run
    unless @run_block.nil?
      instance_eval(&@run_block)
    end
  end

  def puts(*args)
    puts_with_case(*args)
  end

  def puts_dbg(*args)
    puts_with_case(*args) if debug
  end

  private

  def puts_with_case(*args)
    unless case_num.nil?
      @output.print "Case ##{@case_num}: "
    end
    @output.print *args
    @output.print "\n"
  end

end
