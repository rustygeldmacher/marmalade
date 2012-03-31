#!/usr/bin/env ruby

require 'rubygems'
require 'marmalade'

Marmalade.jam do
  read_num_cases
  test_cases do
    read :words, :split => true
    run_case do
      puts @words.reverse.join(' ')
    end
  end
end
