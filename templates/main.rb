#!/usr/bin/env ruby

require 'rubygems'
require 'marmalade'

Marmalade.jam do
  # This assumes your input file has the number of test cases as the first line.
  # Remove the call to read_num_cases this if that is not so.
  read_num_cases

  test_cases do
    # Test case-specific code goes here
  end
end
