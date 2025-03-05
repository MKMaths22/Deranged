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

The FromPermutations class sets up the Outputter and the maths instance variables of @permutation and @positions.
@permutation is the latest permutation, starting from [1, 2, 3, ... n]. This variable will reach all n! permutations before they are sorted for #is_derangement? If they pass that test, they are fed to the Outputter.
The meat of this class is the #find_next_permutation method. The comments in permutations.rb explain what is going on pretty well, but here is an example to make it even clearer:  


Suppose that n = 5 and the current value of @permutation is [3, 5, 4, 2, 1]. Then @positions is [5, 4, 1, 3, 2] because the permutation has 1 in the 5th place, 2 in the 4th place, 3 in the 1st and so on. @positions tells the program where to look for a specific number in the @permutation.
Then we define looking_for to be 1 initially, but keep incrementing it as long as positions[looking_for - 1] + looking_for == n + 1.
In this case, when looking_for = 1, positions[0] + looking_for = 5 + 1 = 6, so we keep going with looking_for = 2.
Then we ask of positions[1] + looking_for = 4 + 2 = 6, so we then set looking_for = 3.
However, the permutation ends in 2, 1 but NOT in 3, 2, 1, so 3 is not as far right as it can go with everything lower after it. Sure enough, positions[2] + looking_for = 1 + 3 = 4 < 6, so we stop incrementing looking_for. Therefore the next permutation is reached by shifting 3 one place higher and putting 1 and 2 at the start in increasing order.  


We go from [3, 5, 4, 2, 1] to [1, 2, 5, 3, 4] In case it is not clear, the program keeps looking for the lowest number it can move one place to the right relative to everything else staying in the same place. So it proceeds:
[1, 2, 5, 3, 4] -> [2, 1, 5, 3, 4] -> [2, 5, 1, 3, 4] -> [2, 5, 3, 1, 4] -> [2, 5, 3, 4, 1] -> [1, 5, 2, 3, 4] -> ..... 4 steps later 1 reaches the end again with [5, 2, 3, 4, 1] -> [1, 5, 3, 2, 4] -> [5, 1, 3, 2, 4] -> [5, 3, 1, 2, 4] -> [5, 3, 2, 1, 4] -> [5, 3, 2, 4, 1] -> [1, 5, 3, 4, 2] -> [5, 1, 3, 4, 2] -> [5, 3, 1, 4, 2] -> [5, 3, 4, 1, 2] -> [5, 3, 4, 2, 1] -> with both 2, 1 at the end, they BOTH get put back to the start and 3 moves up, -> [1, 2, 5, 4, 3] -> ..... much later we reach [5, 4, 3, 2, 1] and stop because a number cannot be moved to the right if everything to the right is LOWER than it.
We can convince ourselves inductively that every permutation is reached because the program reaches every permutation of 5 and 4, say, moving 1, 2, and 3 in all possible positions relative to the 5 and 4 staying in the same place, before we reach [4, 5, 3, 2, 1]. Then the 1, 2, and 3 get reset to the start with 5 and 4 swapped to get [1, 2, 3, 5, 4] and the whole process repeats as it did from [1, 2, 3, 4, 5] to get to [4, 5, 3, 2, 1], we go from [1, 2, 3, 5, 4] to [5, 4, 3, 2, 1].