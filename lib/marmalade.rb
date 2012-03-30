require 'rubygems'
require 'trollop'

require 'marmalade/project_builder'
require 'marmalade/file_reader'
require 'marmalade/puzzle'
require 'marmalade/version'

module Marmalade

  def self.jam(options = {}, &block)
    options = parse_options.merge(options)
    File.open(options[:file], 'r') do |file|
      reader = FileReader.new(file)
      puzzle = Puzzle.new(reader, options)
      puzzle.instance_eval(&block)
    end
  end

  private

  def self.parse_options
    options = Trollop::options do
      opt :file, "Input file to read", :short => 'f', :type => :string
      opt :debug, "Debug mode", :short => 'd', :default => false
      opt :step, "Step through each case", :short => 's', :default => false
      opt :case, "Only run the given case", :short => 'c', :type => :integer, :default => nil
    end
  end

end
