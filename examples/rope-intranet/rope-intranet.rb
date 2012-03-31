#!/usr/bin/env ruby

require 'rubygems'
require 'marmalade'

def intersect?(segment_a, segment_b)
  # They intersect if only one side is higher than the other
  (segment_a[0] - segment_b[0]) * (segment_a[1] - segment_b[1]) < 0
end

# Brute force check all wires
def count_intersections(wires)
  intersections = 0
  wires.length.times do
    wire = wires.pop
    puts_dbg "Wire: #{wire.inspect}"
    wires.each do |other_wire|
      puts_dbg "Other wire: #{other_wire.inspect}"
      intersections += intersect?(wire, other_wire) ? 1 : 0
    end
  end
  intersections
end

Marmalade.jam do
  read_num_cases
  test_cases do
    read :wire_count, :type => :int
    read :wires, :count => @wire_count, :type => :int, :split => true
    run_case do
      puts count_intersections(@wires)
    end
  end
end
