#!/usr/bin/env ruby

$LOAD_PATH.unshift(File.expand_path('../../lib'))
require 'marmalade'

Marmalade.jam do
  read_num_cases
  test_cases do
    read :words, :split => true
    run_case do
      puts_dbg "Input was: #{@words.inspect}"
      puts @words.reverse.join(' ')
    end
  end
end
