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
The above procedure, starting from any derangement is entirely FORCED. Let's park this observation and return to the code.  

The @loop_lengths_collection  
------------------------------------


So, in the program we start with #write_loop_lengths_collection which decomposes n as the sum of integers, each of which at least 2, in every possible way. For n = 9 we get @loop_lengths_collection[9] = [[9], [2, 7], [3, 6], [4, 5], [2, 2, 5], [5, 4], [2, 3, 4], [3, 2, 4], [6, 3], [2, 4, 3], [2, 2, 2, 3], [3, 3, 3], [4, 2, 3], [7, 2], [2, 5, 2], [2, 2, 3, 2], [2, 3, 2, 2], [3, 4, 2], [3, 2, 2, 2], [4, 3, 2], [5, 2, 2]].
The program builds up to this from the base case:
@loop_lengths_collection[2] = [[2]], then
@loop_lengths_collection[3] = [[3]] --- we cannot decompose 3 into 2 numbers each at least 2, so we are done. This is why the while loop in #find_loop_lengths(num) only executes for counter <= num - 2, since num - 1 is too large, with only 1 left over we cannot make loops with one element.
Fast forwarding to show a sufficiently interesting step, when we have done counter = 6 in #write_loop_lengths_collection, we have
@loop_lengths_collection[6] = [[6], [2, 4], [2, 2, 2], [3, 3], [4, 2]], and from earlier cases
@loop_lengths_collection[5] = [[5], [2, 3], [3, 2]]
@loop_lengths_collection[4] = [[4], [2, 2]].
Counter then increments to 7 and we run #find_loop_lengths(num) with num = 7.
At the start we declare @loop_lengths_collection[7] = [[7]] to deal with the case of a single loop of length 7.
We set a new counter = 2 and for each member of @loop_lengths_collection[2] we push 7 - 2 = 5, to cover the cases that finish with a 5.
There is only one possibility for this, namely [2, 5], so now @loop_lengths_collection[7] = [[7], [2, 5]].
Counter increments to 3 and there is only one contribution in this case, so now @loop_lengths_collection[7] = [[7], [2, 5], [3, 4]].
When counter = 4, there are 2 cases, so these have a 3 appended to them before they are appended to the @loop_lengths_collection[7], which is now [[7], [2, 5], [3, 4], [4, 3], [2, 2, 3]].
Counter = 5 ( = 7 - 2) is the last case we need to consider because you cannot use 6, as there would only be 1 left over and loops must have at least 2 elements.
At this last step, 3 possible arrays get added, and the final value of @loop_lengths_collection[7] is [[7], [2, 5], [3, 4], [4, 3], [2, 2, 3], [5, 2], [2, 3, 2], [3, 2, 2]].

Note that all possibilities have been covered because the final loop must be either 2, 3, 4 or 5 elements, before which we must have a member of @loop_lengths_collection[x] for x = 5, 4, 3 or 2, apart from the trivial case of [7] which we started with.

Remember that earlier procedure that starts with a derangement and produces an ORDERED sequence of loop_lengths based on each loop starting with the LOWEST unused number so far? This allows us to START with a specific array of @loop_lengths, as in the #calculate_derangements method such as @loop_lengths = [4, 2, 3] when n = 9 and then CONSTRUCT all derangements of n = 9 for which the loop containing '1' has 4 elements and the loop containing the next smallest number has 2 elements and the other 3 elements form a loop. Included in these will be our example of [2, 5, 9, 1, 4, 8, 6, 7, 3].
So we need to know what the @parameters and @variables are that generate the set of derangements for these particular @loop_lengths. The way I thought about this was:
'How much freedom do we have to find such a derangement?'
The first loop will have 4 elements. We have no choice for the 1st one, which must be '1' by definition of 'first loop'. The next one could be any of 8 possibilities 2, 3, 4 ... or 9. The third member of that loop has 7 remaining possibilities and the 4th has 6 possible choices.
For the second loop, the first element is forced as it must be the lowest number not used in the first loop. But the 2nd and final member of that loop now has 4 possible options.
In the 3rd loop, the first element is similarly forced. Then we have 2 choices for the next element and just 1 choice (so forced again) for the final element.

@parameters are the variables representing the 'choices' we make including the forced ones. Of these the @variables include only the unforced choices.
The @parameter_limits count how many choices we have for each element as we choose them above. For @loop_lengths = [4, 2, 3] the @parameter_limits are [1, 8, 7, 6, 1, 4, 1, 2, 1].
Notice that this is just [9, 8, 7, 6, 5, 4, 3, 2, 1] but with the first elements of each loop forced, the initial 9, 5th value (value 4 in the code) 5 and 7th (value 6 in the code) get replaced by 1 to reflect this. This is how #update_parameter_limits works. #update_variables uses the @parameter_limits to observe which parameters are not forced. The @variables are given according to the computer-indexed parameters so in this case @variables = [1, 2, 3, 5, 7] because we have forced parameters in positions 0, 4, 6 and 8 (starts of the loops and the final forced choice).

How do the values of the @parameters determine actual @named_loops and then a @derangement to be outputted?
The @named_loops just concatenate the distinct loops of the derangement. For our example derangement [2, 5, 9, 1, 4, 8, 6, 7, 3], with @loop_lengths of [4, 2, 3] and loops of [1, 2, 5, 4], [3, 9] and [6, 8, 7], the @named_loops will need to equal [1, 2, 5, 4, 3, 9, 6, 8, 7]. This defines the derangement uniquely IN CONTEXT with the @loop_lengths because knowing the lengths lets us separate that @named_loops array in the right way to get the actual loops and then the derangement. *With different loop lengths, the SAME @named_loops would represent a different derangement.*

When the value of a parameter is k, that means when choosing our numbers to go in the loops, we are told to choose the k'th smallest value of the possible numbers remaining (which depends on the previous numbers chosen). Parameters which are forced take value 1 every time, variable parameters will take values 1, 2, 3, .... or L where L is the corresponding @parameter_limit. So for our example with n = 9, @loop_lengths of [4, 2, 3] which means @parameter_limits are [1, 8, 7, 6, 1, 4, 1, 2, 1], then all of the corresponding derangements will be found by letting the parameters take values [always 1, anything 1 - 8, anything 1 - 7, anything 1 - 6, always 1, anything 1-4, always 1, 1 or 2, always 1]. Each choice of values for the parameters forces the choices for the numbers in the loops and therefore the derangements so there are 8 x 7 x 6 x 4 x 2 = 2688 derangements for n = 9 with @loop_lengths of [4, 2, 3]. Our particular derangement [2, 5, 9, 1, 4, 8, 6, 7, 3] with @named_loops of [1, 2, 5, 4, 3, 9, 6, 8, 7] will be generated when the @parameters = [1, 1, 3, 2, 1, 4, 1, 2, 1].

The code uses recursion in #lexicographically_enumerate_parameter_values_to_generate_derangements to ensure that the @parameters take all of the possible combinations of values allowed by the @parameter_limits. For each instance of @parameters, we get the @named_loops updated with #modify_named_loops and then #modify_derangement updates the derangement before #output_derangement gives that to the Outputter. Let's see this working with a relativey simple example:

If n = 7 and @loop_lengths = [2, 3, 2], we get @parameter_limits = [1, 6, 1, 4, 3, 1, 1] and @variables = [1, 3, 4]. After #reset_parameter_values, #parameters = [1, 1, 1, 1, 1, 1, 1] and #reset_named_loops has ran as well, @named_loops = [1, 2, 3, 4, 5, 6, 7]. 
After #update_loop_vector, @loop_vector = [1, 0, 3, 4, 2, 6, 5]. What this tells us is that from the 1st element we go to the one in position 1 (the 2nd one using human counting), but from the 2nd one we loop back to position 0 (1st one, human counting) because the first loop has length 2. Then element 2 goes to 3, 3 goes to 4 and 4 goes back to 2 (a loop of length 3) and 5 goes to 6 and 6 back to 5, finishing with a loop of length 2.

Then #modify_derangement[0] runs, with the argument of 0 telling us we are changing the values 'from variable 0' because the memoization cannot help us here as we are just starting with new @loop_lengths and there is no previous derangement to modify.
In #modify_derangement(0), index = 0. Then, its while loop uses 

@derangement[named_loops[index] - 1] = named_loops[loop_vector[index]]

to first set @derangement[named_loops[0] - 1] = named_loops[loop_vector[0]]. loop_vector[0] = 1 and named_loops[1] = 2 so the first number 1 is being sent to 2. Left hand side is @derangement[1 - 1] so the @derangement starts [2....]. Then index increments to 1 and we get 
@derangement[named_loops[1] - 1] = named_loops[loop_vector[1]] so on the left we are determining @derangement[2 - 1], i.e. @derangement[1], the 'second' number in the derangement, where 2 gets mapped to. On the RHS named_loops[loop_vector[1]] = named_loops[0] = 1, so the loop vector is telling us to go back to 1 again and the @derangement now starts [2, 1, ....].
Eventually we end up with @derangement = [2, 1, 4, 5, 3, 7, 6] which indeed has loops of [1, 2], [3, 4, 5] and [6, 7]. It's not easy to explain this process because of the human-counting and computer-counting of numbers at different stages, which was one of the things that made writing this code more challenging.
