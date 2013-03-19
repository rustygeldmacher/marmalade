#!/usr/bin/env ruby

$LOAD_PATH.unshift(File.expand_path('../../lib'))
require 'marmalade'

class TestCase
  def each_dir(path)
    path.split('/').reject { |d| d.nil? || d == '' }.each do |dir|
      yield dir
    end
  end

  def mkdir(path, root)
    created = 0
    cwd = root
    puts_dbg "path: #{path}"
    each_dir(path) do |dir|
      puts_dbg "dir: #{dir}"
      unless cwd.include?(dir)
        puts_dbg "needs creating"
        cwd[dir] = {}
        created += 1
      end
      cwd = cwd[dir]
    end
    created
  end

  def solve(existing, to_create)
    root = {}
    existing.each do |path|
      cwd = root
      each_dir(path) do |dir|
        cwd[dir] ||= {}
        cwd = cwd[dir]
      end
    end
    created = 0
    to_create.each do |path|
      created += mkdir(path, root)
    end
    created
  end
end

Marmalade.jam do
  read_num_cases
  test_cases do
    read [:e, :c], :type => :int
    read :existing, :count => @e
    read :to_create, :count => @c
    run_case do
      puts_dbg "Existing:"
      @existing.each { |f| puts_dbg f }
      puts_dbg "To create:"
      @to_create.each { |f| puts_dbg f }
      puts solve(@existing, @to_create)
    end
  end
end
