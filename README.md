This README details my own project instructions for Deranged, my first Ruby Maths project.

Instructions:

1) Make it so that if I type 'Ruby deranged.rb' I get a prompt asking for a positive integer.

2) If the input is not a positive integer, or is too large (decide how large this should be) then an error message is shown.

3) Otherwise, the program outputs a list of all the derangements of [1, 2, 3, .... n] for that value of n, and writes that output to a text file output.txt in the following format:
[2, 3, 4, 1]
[2, 4, 1, 3]... etc. for n = 4.

4) It should be possible to easily tweak the program between two different ways of calculating the derangements, so that I can compare the speed of the methods.

NOTES:  
---------------------------------------------

The program now asks you whether you wish to calculate via permutations or by constructing derangements from loops. If the latter, the program also asks if you want memoization during the calculation. As well as outputting the derangements in output.txt (a file that is created or rewritten as required), it also outputs the time taken. Experimentation shows that loops are better than permutations for larger values of n. However the effect of memoization is sometimes negligable, a surprising result!


There are now Minitest tests in tests.rb which can be run with the command 'ruby tests.rb' but it is recommended that you first comment out the 'Derangements.new' command at the end of derangements.rb. The tests can be run without doing this, but then the Derangements.new line will run when the tests run, causing you to be asked the questions for a number and method etc.. as another instance of the program runs alongside the tests. As of writing this, I am not sure how to better deal with this issue.

The Mathematical Method and how to follow the code.  
--------------------------------------------

The FromPermutations class sets up the Outputter and the maths instance variables of @permutation and @positions.
@permutation is the latest permutation, starting from [1, 2, 3, ... n]. This variable will reach all n! permutations before they are sorted for #is_derangement? If they pass that test, they are fed to the Outputter.
The meat of this class is the #find_next_permutation method. The comments in permutations.rb explain what is going on pretty well, but here is an example to make it even clearer:  


Suppose that n = 5 and the current value of @permutation is [3, 5, 4, 2, 1]. Then @positions is [5, 4, 1, 3, 2] because the permutation has 1 in the 5th place, 2 in the 4th place, 3 in the 1st and so on. @positions tells the program where to look for a specific number in the @permutation.
Then we define looking_for to be 1 initially, but keep incrementing it as long as positions[looking_for - 1] + looking_for == n + 1.
In this case, when looking_for = 1, positions[0] + looking_for = 5 + 1 = 6, so we keep going with looking_for = 2.
Then we ask of positions[1] + looking_for = 4 + 2 = 6, so we then set looking_for = 3.
However, the permutation ends in 2, 1 but NOT in 3, 2, 1, so 3 is not as far right as it can go with everything lower after it. Sure enough, positions[2] + looking_for = 1 + 3 = 4 < 6, so we stop incrementing looking_for. Therefore the next permutation is reached by shifting 3 one place higher and putting 1 and 2 at the start in increasing order.  


We go from [3, 5, 4, 2, 1] to [1, 2, 5, 3, 4]. The ordering of the 3, 4, and 5 values has moved on to the 'next permutation' of those values with the 1 and 2 put back at the start. We then move the 1 through the other values to the right hand end before resetting it and moving 2 to the right, ensuring that with the 3, 4, and 5 in this order, the 1 and 2 take up all of their possible positions relative to that order [5, 3, 4]. In case it is not clear, the program keeps looking for the lowest number it can move one place to the right relative to everything else staying in the same place. So it proceeds:
[1, 2, 5, 3, 4] -> [2, 1, 5, 3, 4] -> [2, 5, 1, 3, 4] -> [2, 5, 3, 1, 4] -> [2, 5, 3, 4, 1] -> [1, 5, 2, 3, 4] -> ..... 4 steps later 1 reaches the end again with [5, 2, 3, 4, 1] -> [1, 5, 3, 2, 4] -> [5, 1, 3, 2, 4] -> [5, 3, 1, 2, 4] -> [5, 3, 2, 1, 4] -> [5, 3, 2, 4, 1] -> [1, 5, 3, 4, 2] -> [5, 1, 3, 4, 2] -> [5, 3, 1, 4, 2] -> [5, 3, 4, 1, 2] -> [5, 3, 4, 2, 1] -> with both 2, 1 at the end, they BOTH get put back to the start and 3 moves up, -> [1, 2, 5, 4, 3] -> ..... much later we reach [5, 4, 3, 2, 1] and stop because a number cannot be moved to the right if everything to the right is LOWER than it.
We can convince ourselves inductively that every permutation is reached because the program reaches every permutation of 5 and 4, say, moving 1, 2, and 3 in all possible positions relative to the 5 and 4 staying in the same place, before we reach [4, 5, 3, 2, 1]. Then the 1, 2, and 3 get reset to the start with 5 and 4 swapped to get [1, 2, 3, 5, 4] and the whole process repeats as it did from [1, 2, 3, 4, 5] to get to [4, 5, 3, 2, 1], we go from [1, 2, 3, 5, 4] to [5, 4, 3, 2, 1].  

Constructing Derangements from Loops.  
---------------------------------------------

I wanted to find a constructive system for expressing the derangements of [1, 2, .... n] in which we don't find all permutations first and then have to reject them if they have fixed points, as in the FromPermutations class.
If we regard a derangement as a function from the set {1, 2, ... n} to itself, it is defined as a bijective function with no fixed points. So we can meaningfully ask --- what is the loop containing the number 1? It is defined to be the set of values taken by f^i(1) as i varies through the integers, and is guaranteed to contain 1 and at least 1 other value, so could be between 2 and all n elements in size. Essentially we keep applying the function f, starting at the value 1 and stopping when we return to 1.  

If we disregard the values contained in that loop, which we can call the 'first loop', expressable in ORDER starting from 1 and finishing with f^(-1)(1), the remaining values, if there are any, will have a smallest member, which could be 2, or some other value (if 2 was in the first loop).
By starting at the smallest remaining value, we can ask what are the values in its loop, by applying f repeatedly from that smallest remaining value. This is the 'second loop', and can be expressed in order starting from its smallest value. By continuing in this way, we can, in a UNIQUE way, express any derangement as a sequence of loops, each with size of at least 2 elements, and n = the total length of the loops.

For example, with n = 9, consider the derangement [2, 5, 9, 1, 4, 8, 6, 7, 3].
Starting from 1, f(1) = 2, f(2) = 5, f(5) = 4 and f(4) = 1, so the first loop is [1, 2, 5, 4]
Smallest remaining value is 3, so f(3) = 9, f(9) = 3 and the second loop is [3, 9].
Smallest remaining value is 6, so f(6) = 8, f(8) = 7 and f(7) = 6. The third loop is [6, 8, 7] and all nine values have been accounted for.  

How does this allow us to neatly list the derangements on n = 9, covering each one exactly once?
The above procedure, starting from any derangement is entirely FORCED.   

So, in the program we start with #write_loop_lengths_collection which decomposes n as the sum of integers, each of which at least 2, in every possible way. For n = 9 we get @loop_lengths_collection[9] = [[9], [2, 7], [3, 6], [4, 5], [2, 2, 5], [5, 4], [2, 3, 4], [3, 2, 4], [6, 3], [2, 4, 3], [2, 2, 2, 3], [3, 3, 3], [4, 2, 3], [7, 2], [2, 5, 2], [2, 2, 3, 2], [2, 3, 2, 2], [3, 4, 2], [3, 2, 2, 2], [4, 3, 2], [5, 2, 2]].
The program builds up to this from the base case:
@loop_lengths_collection[2] = [[2]], then
@loop_lengths_collection[3] = [[3]] --- we cannot decompose 3 into 2 numbers each at least 2, so we are done. This is why the while loop in #find_loop_lengths(num) only executes for counter <= num - 2, since num - 1 is too large, with only 1 left over we cannot make loops with one element.
Fast forwarding to show a sufficiently interesting step, when we have done counter = 6 in #write_loop_lengths_collection

