# Marmalade

A Ruby library for helping with the boring, mechanical part of Google Code Jam puzzles, letting you focus on solving the problem instead of setting up the scaffolding.

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

## Basic Usage

Once you create a Ruby file for solving a Code Jam puzzle, simply put `require 'marmalade'` at the top. Make the file executable and Marmalade is ready to do the dirty work for you. Say we have an input file like the one described above. The first number in each test case is called `k` and the second is `n`, which is the number of `lines` to read in for each puzzle. Assuming we have a method called `solve_case` that returns the result we're looking for, we can instruct Marmalade to read that for us like so:

    Marmalade.jam(:file => 'input.txt') do
      read :num_cases, :type => :int
      test_cases do
        read [:k, :n], :type => :int
        read :lines, :count => @n
        puts solve_case(@k, @lines)
      end
    end

Marmalade reads in each line and will assign the values to instance variables that you specify (in this case, `@k`, `@n` and `@lines`). When the result is ready to be printed, Marmalade overrides `puts` to use the proper output format that Code Jam usually requires, much like:

    Case #1: 12
    Case #2: 55
    # and so on...

## Reading strings

The `read` call will interpret lines and values as strings by default. So, to read strings you simply want to omit the `:type => :int` declaration on `read`.

## Splitting lines

Many times, Code Jam puzzles have lines with multiple values that you want to process as an array. For instance if you have a line like the following:

    A B C D E

And you want to process that as an array, you can use the `:split` argument to `read` like so:

    read :letters, :split => true
    
The result would be an instance variable `@letters` with will be the array `['A', 'B', 'C', 'D', 'E']`. Similarly, if the line were a series of number like this:

    1 2 3 4 5 6 7

You can combine `:split` with `:type`:

    read :numbers, :split => true, :type => :int
    
The `@numbers` instance variable would then contain the array `[1, 2, 3, 4, 5, 6, 7]`.

## Debugging

Marmalade gives you a few ways to help you debug as you solve puzzles. Firstly, you can pass `:debug => true` into the `jam` method, which enabled debug mode. As you go along, you can use `puts_dbg` to write debug messages to the console only if debug mode is enabled. This comes in handy when you want to do your final run to generate your submitted output file.

Passing `:step => true` into the `jam` method will cause Marmalade to pause for user input between every test case. This is particularly handy when your'e validating your solution to a puzzle and want to follow your debug output as the program runs through test cases.

Sometimes you hit a tricky test case and want to work on just that case. Passing `:case => X` into `jam` will cause it to only process case X and skip all other cases. However, in order to enable this functionality, you must tell Marmalade which code in your test cases is used to process, rather than read, test data. Taking the example from above, we can enable the use of `:step` like this:

    Marmalade.jam(:file => 'input.txt', :case => 5) do
      read :num_cases, :type => :int
      test_cases do
        read [:k, :n], :type => :int
        read :lines, :count => @n
        run_case do
          puts solve_case(@k, @lines)
        end
      end
    end

By placing the call to `solve_case` in a `run_case` block, Marmalade knows to skip this code if it's looking for a particular case to run. In this example, `solve_case` will only run for case 5.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
