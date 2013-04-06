require 'rubygems'
require 'trollop'
require 'parallel'

require 'marmalade/project_builder'
require 'marmalade/file_reader'
require 'marmalade/test_case'
require 'marmalade/puzzle'
require 'marmalade/version'

# A class to use for throwing error internally.
class MarmaladeError < Exception; end

module Marmalade

  def self.jam(options = {}, &block)
    options = parse_options.merge(options)
    begin
      file_name = options[:file]
      unless File.exist?(file_name)
        raise MarmaladeError.new("Cannot find input file #{file_name}")
      end
      File.open(file_name, 'r') do |file|
        reader = FileReader.new(file)
        puzzle = Puzzle.new(reader, options)
        puzzle.instance_eval(&block)
      end
    rescue MarmaladeError => e
      puts "** Error: #{e.message}"
    end
  end

  private

  def self.parse_options
    Trollop::options do
      opt :file, "Input file to read", :short => 'f', :type => :string
      opt :debug, "Debug mode", :short => 'd', :default => false
      opt :step, "Step through each case", :short => 's', :default => false
      opt :case, "Only run the given case", :short => 'c', :type => :integer, :default => nil
      opt :parallel, "Run the cases in parallel processes", :short => 'p', :default => false
      opt :processes, "Specify the number of processes to use", :type => :integer
    end
  end

end
