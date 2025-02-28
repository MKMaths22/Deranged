This README details my own project instructions for Deranged, my first Ruby Maths project.

Instructions:

1) Make it so that if I type 'Ruby deranged.rb' I get a prompt asking for a positive integer.

2) If the input is not a positive integer, or is too large (decide how large this should be) then an error message is shown.

3) Otherwise, the program outputs a list of all the derangements of [1, 2, 3, .... n] for that value of n, and writes that output to a text file output.txt in the following format:
[2, 3, 4, 1]
[2, 4, 1, 3]... etc. for n = 4.

4) It should be possible to easily tweak the program between two different ways of calculating the derangements, so that I can compare the speed of the methods.

---------------------------------------------

NOTES:

The program now asks you whether you wish to calculate via permutations or by constructing derangements from loops. If the latter, the program also asks if you want memoization during the calculation. As well as outputting the derangements in output.txt (a file that is created or rewritten as required), it also outputs the time taken. Experimentation shows that loops are better than permutations for larger values of n. However the effect of memoization is sometimes negligable, a surprising result!


There are now Minitest tests in tests.rb which can be run with the command 'ruby tests.rb' but it is recommended that you first comment out the 'Derangements.new' command at the end of derangements.rb. The tests can be run without doing this, but then the Derangements.new line will run when the tests run, causing you to be asked the questions for a number and method etc.. as another instance of the program runs alongside the tests. As of writing this, I am not sure how to better deal with this issue.

--------------------------------------------

The Mathematical Method and how to follow the code.

