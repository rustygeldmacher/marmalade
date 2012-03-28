# Marmalade

A Ruby library for helping with the rote, boring part of Google Code Jam puzzles, letting you focus on solving the problem instead of setting up the scaffolding.

Most Code Jam input files look like something like this:

    100     # Number of test cases
    5 3     # Some data about case 1, say a number then some numnber of lines to read next
    123     # First line to read
    456     # Second line to read
    789     # Third line to read
    9 8     # Start of test case 2
    
When beginning a puzzle, wouldn't it be nice to focus on what you need to do to solve it rather than messing with read in the file in the right increments, debugging it, and making sure its doing what you expect? This is where Marmalade comes in. It gives you tools to use in order to quickly get down to the work of solving the actual problem. After all, time is of the essence!

## Installation

Install via RubyGems:

    $ gem install marmalade

## Usage

### Basic Usage

Once you create a Ruby file for solving a Code Jam puzzle, simply require the Marmalade gem:

    #!/usr/bin/env ruby
    
    require 'rubygems'
    require 'marmalade'
   
Make the file executable and Marmalade is ready to do the dirty work for you. Say we have an input file like the one described above. The first number in each test case is called `k` and the second is `n`, which is the number of `lines` to read in for each puzzle. Assuming we have a method called `solve_case` that returns the result we're looking for, we can instruct Marmalade to read that for us like so:

    Marmalade.jam do
      read :num_cases, :type => :int
      test_cases do
        read [:k, :n], :type => :int
        read :lines, :count => @n
        puts_res solve_case(@k, @lines)
    end

Marmalade reads in each line and will assign the values to instance variables that you specify. When the result is ready to be printed, calling `puts_res` will output the proper format that Code Jam usually requires, much like:

    Case #1: 12
    Case #2: 55
    # and so on...

### Other Stuff

- --debug and puts_dbg
_ --case
- --step and run_case
- reading with :split
- reading strings

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
