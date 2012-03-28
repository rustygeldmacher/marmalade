module Marmalade
  # A class to help parsing out values from a Code Jam input file
  class FileReader
    attr_accessor :file_handle

    def initialize(file_handle)
      self.file_handle = file_handle
    end

    # Reads the next values from the file and returns them as a hash
    def read(assignments, options = {})
      line_count = options[:count]
      read_options = options.dup
      if assignments.is_a?(Array)
        read_options[:split] = true
      end
      lines = 1.upto(line_count || 1).map { read_line(file_handle, read_options) }
      lines = line_count.nil? ? lines.first : lines
      assign_results(assignments, lines)
    end

    private

    def read_line(file_handle, options)
      line = file_handle.gets.strip
      integers = [:int, :integer].include?(options[:type])
      if options[:split]
        line_a = line.split(' ')
        if integers
          line_a = line_a.map(&:to_i)
        end
        line_a
      elsif integers
        line = line.to_i
      else
        line
      end
    end

    def assign_results(assignments, lines)
      Hash.new.tap do |assigns|
        if assignments.is_a?(Symbol)
          assigns[assignments] = lines
        elsif assignments.is_a?(Array)
          assignments.each_with_index do |var, i|
            assigns[var] = lines[i]
          end
        end
      end
    end
  end
end
