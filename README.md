# Marmalade

A Ruby library for helping with the boring, mechanical part of Google Code Jam puzzles, letting you focus on solving the problem instead of setting up the scaffolding.

Most Code Jam input files look like something like this:

    100     # Number of test cases
    5 3     # Some data about case 1, say a number then some numnber of lines to read next
    123     # First line to read
    456     # Second line to read
    789     # Third line to read
    9 8     # Start of test case 2

When beginning a puzzle, wouldn't it be nice to focus on what you need to do to solve it rather than messing with reading the file in the right increments, debugging it, and making sure it's doing what you expect? This is where Marmalade comes in. It gives you tools to use in order to quickly get down to the work of solving the actual problem. After all, time is of the essence!

## Installation

Install via RubyGems:

    $ gem install marmalade

At the moment, the requirements for using it are:

- A *nix environment
- Ruby 1.9

## Basic Usage

Once the gem is installed, use the generator to create yourself a project:

    $ jam example

This command will create a directory called `example` under the current directory and will create a file in the directory called `example.rb`, which is an executable Ruby file set up for using Marmalade to do the dirty work for you. Running this file with the `--help` option lets you know about a few things it can do out of the box:

       $ cd example
       $ ./example.rb --help
       Options:
         --file, -f <s>:   Input file to read
            --debug, -d:   Debug mode
             --step, -s:   Step through each case
         --case, -c <i>:   Only run the given case
         --parallel, -p:   Run the cases in parallel processes
    --processes, -r <i>:   Specify the number of processes to use
             --help, -h:   Show this message

Say we have an input file like the one described above. The first line of the file declares how many test cases the file contains. The first number in each test case is called `k` and the second is `n`, which is the number of `lines` to read in for each puzzle. Assuming we have a method called `solve_case` that returns the result we're looking for, we can edit example.rb and instruct Marmalade to read that for us like so:

    Marmalade.jam do
      read_num_cases
      test_cases do
        read [:k, :n], :type => :int
        read :lines, :count => @n
        run_case do
          puts solve_case(@k, @lines)
        end
      end
    end

Assuming our input file is called `sample.txt`, we can now run the puzzle like this:

    $ ./example -f sample.txt

Marmalade reads in each line and will assign the values to the instance variables that you specified (in this case, `@k`, `@n` and `@lines`). When the result is ready to be printed, Marmalade overrides `puts` to use the proper output format that Code Jam usually requires, much like:

    Case #1: 12
    Case #2: 55
    # and so on...

## Using multiple cores

Marmalade supports running test cases over multiple CPU cores by running them in parallel processes. In order to run your cases in parallel, supply the `--parallel` command line option to the script. For example:

    ./example.rb -f input_file.txt --parallel

When this option is supplied, Marmalade will use as many processes as there are CPU cores on your machine. To control how many processes are used, supply the `--processes=X` command line option. For instance, to run a test using 4 parallel processes, do the following:

    ./example.rb -f input_file.txt --processes=4

Note that if you supply a processes count, you do not have to also supply the `--parallel` option.

## Reading the number of test cases

As shown in the example above, the call to `read_num_cases` reads the next line from the file, interpreting it as an integer and assigning it to the `@num_cases` instance variable. It is functionally equivalent to the following call:

    read :num_cases, :type => :int

`@num_cases` is important because it lets the `test_cases` block know how many cases to run. If `@num_cases` has not been assigned by the time `test_cases` is called, then Marmalade will throw an error.

## Reading strings

The `read` call will interpret lines and values as strings by default. So, to read strings you simply want to omit the `:type => :int` declaration on `read`.

## Splitting lines

Many times, Code Jam puzzles have lines with multiple values that you want to process as an array. For instance if you have a line like the following:

    A B C D E

By default, Marmalade will read that line as a single strin. If you'd rather read it as an array, you can use the `:split` argument to `read` like so:

    read :letters, :split => true

The result would be an instance variable `@letters` which will be the array `['A', 'B', 'C', 'D', 'E']`. Similarly, if the line were a series of number like this:

    1 2 3 4 5 6 7

You can combine `:split` with `:type`:

    read :numbers, :split => true, :type => :int

The `@numbers` instance variable would then contain the array `[1, 2, 3, 4, 5, 6, 7]`.

Finally, here is how you'd read multiple lines of integer arrays:

    read :matrix, :count => 3, :split => true, :type => :int

If you had an input file that looks like this:

    1 2 3
    4 5 6
    7 8 9

Then the `@matrix` instance variable will be an array of arrays: `[[1, 2, 3], [4, 5, 6], [7, 8, 9]]`.

## Helper methods

There are two ways to define methods that help you organize your solution code. The first is to simple define the method right within the `run_case` block like so:

    Marmalade.jam do
      read_num_cases
      test_cases do
        read :words, :split => true
        run_case do
          def solve_case(arr)
            puts_dbg "array is: #{arr.inspect}"
            arr.reverse
          end
          puts solve_case(@words)
        end
      end
    end

The second (and preferable) way is to open the `TestCase` class and define methods there. Since code within a `run_case` block runs within the context of a `TestCase` instance, all methods defined within that class will be available when running the case.

    class TestCase
      def solve_case(arr)
        puts_dbg "array is: #{arr.inspect}"
        arr.reverse
      end
    end

    Marmalade.jam do
      read_num_cases
      test_cases do
        read :words, :split => true
        run_case do
          puts solve_case(@words)
        end
      end
    end

Of course, defining methods in the global context of the file itself will work fine, but then they won't have access to the instance variables read from the file, or the modified `puts` or `puts_dbg` methods (see below).

## Debugging

Marmalade gives you a few ways to help debug as you solve puzzles. Firstly, you can pass `--debug` as a command line argument, which enables debug mode. As you go along, you can use `puts_dbg` to write debug messages to the console only if debug mode is enabled. This comes in handy when you want to do your final run to generate your submitted output file.

Passing the `--step` command line argument will cause Marmalade to pause for user input between every test case. This is particularly handy when you're validating your solution to a puzzle and want to follow your debug output as the program runs through test cases.

Sometimes you hit a tricky test case and want to work on just that case. Passing `--case X` will cause it to only process case X and skip all other cases. However, in order to enable this functionality, you must make sure the work in each case is done in a `run_case` block. For example, this command:

    $ ./example.rb -f sample.txt --case 5

Will run `solve_case` only for test case 5.

## Updating from 0.2 to 0.3

Two things have changed between v0.2 and v0.3 that may break your previous scripts:

* In version 0.2, Marmalade did not require that test case code was contained in a `run_case` block. This is now required.
* Version 0.2 was able to use globally-scoped helper functions, which is now deprecated. For version 0.3, please open the TestCase class or create helper methods directly in the `run_case` block.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
