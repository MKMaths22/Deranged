class ConstructLoops

  attr_reader :n, :parameter_limits, :loop_lengths_collection, :loop_lengths, :loop_vector, :outputter, :testing
  attr_accessor :parameter_values, :named_loops, :derangement, :variables, :change_from_index, :memo_hash, :remaining_named_loop_values, :memory, :add_puts

  def initialize(n = 7, testing = false, memory = true)
    # the Boolean at the end tells this class that we are in 'testing' mode, so that the Outputter class will
    # take care of counting and aggregating the derangements fed into it
    @memory = testing ? memory : ask_if_memory
    memory = @memory
    # the above line seems to be needed so that when we enquire the variable 'memory' we don't have the bug of the
    # inputted 'memory' value being accessed instead of the accessor for @memory.
    @n = n
    @testing = testing
    @outputter = Outputter.new(testing)
    @loop_lengths_collection = Hash.new([])
    # loop_lengths_collection will be a Hash with a key of 2, 3, ... n - 2 or n 
    @loop_lengths = []
    @parameter_values = Array.new(n, 1)
    @parameter_limits = ((n - 1).times.map { |num| (n - 1) - num }).unshift(1)
    @variables = []
    update_variables
    @loop_vector = []
    @named_loops = n.times.map { |num| num + 1 }
    @derangement = []
    @change_from_index = memory ? variables[-1] : 0
    @remaining_named_loop_values = n.times.map { |num| num + 1 }
    @memo_hash = Hash.new() if memory
    # parameter_limits starts as [1, n - 1, n - 2 .... 1]
    @add_puts = false
  end

  def ask_if_memory
    puts "Would you like Ruby to remember previous values to help it find derangements quicker?"
    puts "Answer Y for Yes or anything else for No."
    gets.downcase.strip.chars[0] == 'y' ? true : false
  end

  def calculate_derangements
    write_loop_lengths_collection
    loop_lengths_collection[n].each do |array|
      update_loop_lengths(array)
      @add_puts = array == [2, 3, 2] ? true : false
      set_parameter_limits_and_variables_etc_for_new_loop_lengths
      lexicographically_enumerate_parameter_values_to_generate_derangements(0)
    end
    @outputter.finish_output
  end

  def write_loop_lengths_collection
    @loop_lengths_collection[2] = [[2]]
    counter = 3
      while counter <= n do
        find_loop_lengths(counter) unless counter == n - 1
        # we don't need to know the loop_lengths for n - 1 case because this does not contribute to the n case.
        counter += 1
      end
  end

  def find_loop_lengths(num)
    @loop_lengths_collection[num] = [[num]]
    counter = 2
      while counter <= num - 2 do
        @loop_lengths_collection[counter].each do |array|
          @loop_lengths_collection[num].push(array.clone.push(num - counter))
        end
        counter += 1
      end
  end

  def set_parameter_limits_and_variables_etc_for_new_loop_lengths
    update_parameter_limits
    update_variables
    reset_parameter_values
    reset_named_loops
    update_loop_vector
    if memory
      reset_change_from_index 
      reset_remaining_named_loop_values
      set_memo_hash
    end
    modify_derangement(0)
  end

    # loop_lengths is for example [3, 4, 2] from which we will get all derangements of n = 9 in which the element '1' is in a loop of length 3 and the next lowest
    # element not yet chosen is in a loop of length 4 and the remaining elements make a loop of length 2.
    # the parameters are numbered in the computer-indexed way from 0 to n - 1, and correspondingly the variables, which are the parameters with limit at least 2
    # the VALUES of the parameters/variables are human-indexed, where 1 means lowest-available value etc.


    # parameter_limits is the array telling us how many choices we have for each member of the loops. For example, for [3, 4, 2] we get [1, 8, 7, 1, 5, 4, 3, 1, 1]
    
    # After reset_parameter_values they are [1, 1, 1, .... 1]. The #lexicographically_enumerate... below generates the next option lexicographically until we reach the upper limit for each choice.
    # But if we keep updating the parameter_values lexico and then generate the named_loops from that (and then the derangement itself trivially) then lots of steps will be repeated.
    # Can we 'save our progress' so that we ONLY UPDATE the parts that have changed from changing the parameter values? Then the earlier part of the named loops can be kept and not
    # recreated in exactly the same way.
    # This is what the memo_hash and change_from_index achieve when @memory = true, although this does not seem to make the program quicker.


  def lexicographically_enumerate_parameter_values_to_generate_derangements(variable_index)
  # variable index goes from 0 to current_variables.size - 1, telling us which variable we are dealing from.
  # As this method recursively calls other versions of itself, it causes the variables to reach all possible combinations,
  # and therefore the parameters too (because the other parameters do not change anyway.
    parameter_number = variables[variable_index]
    number_of_values_taken = parameter_limits[parameter_number]
    number_of_values_taken.times do |cycle|
      if variable_index + 1 == variables.size
        # only evaluate the named_loops, derangement when the variable is the last one
        modify_named_loops
        modify_derangement
        output_derangement 
      else lexicographically_enumerate_parameter_values_to_generate_derangements(variable_index + 1)
      end
      if cycle + 1 == number_of_values_taken 
        parameter_values[parameter_number] = 1 
      else
        parameter_values[parameter_number] += 1
        @change_from_index = memory ? parameter_number : 0
        puts "change_from_index updated to #{change_from_index} with variable_index #{variable_index} and parameter_number = #{parameter_number}." if add_puts
        if memory 
          remaining_named_loop_values = named_loops[change_from_index..-1].clone.sort
          puts "remaining named loop values updated to #{remaining_named_loop_values}" if add_puts
          memo_hash[parameter_number] = remaining_named_loop_values.clone if cycle == 0
          puts "Memo_hash updated so that for key #{parameter_number} we have value #{remaining_named_loop_values} because cycle = #{cycle}." if add_puts
        end
      end
    end
  end

  def modify_named_loops(from = change_from_index)
    index = from
    if memory
      @remaining_named_loop_values = memo_hash[index].clone
      puts "In #modify_named_loops, the current @named_loops are #{named_loops}. Remaining_named_loop_values updated to be #{remaining_named_loop_values}." if add_puts
    end
    temporary_remaining_values = remaining_named_loop_values.clone
    # the remaining values from the set (1...n), disregarding those values used before index = from in the current_named_loops
    # temp... and remaining... are sorted in increasing order, so we can take the correct values based on the parameter_values
    while index < n do
      index_to_use = parameter_values[index] - 1
      value_to_use = temporary_remaining_values[index_to_use]
      named_loops[index] = value_to_use
      temporary_remaining_values.delete_at(index_to_use)
      index += 1
    end
  end

  def modify_derangement(from = change_from_index)
    puts "At start of #modify_derangement, @derangement = #{derangement} and from = change_from_index = #{from}." if add_puts
    index = from.zero? ? 0 : from - 1
    while index < n do
      @derangement[named_loops[index] - 1] = named_loops[loop_vector[index]]
      puts "During the while loop, the derangement has changed to #{derangement}" if add_puts
      index += 1
    end
  end

  private
  
  def update_parameter_limits
    reset_parameter_limits
    index_to_change = 0
    loop_lengths.each do |length|
      index_to_change += length
      @parameter_limits[index_to_change] = 1 unless index_to_change == n
    end
  end

  def update_variables
    variables = []
    parameter_limits.each_with_index do | limit, parameter |
    @variables = variables.push(parameter) if limit >= 2
    end
  end
  
  def update_loop_lengths(array)
    @loop_lengths = array
  end

  def update_loop_vector
    # the current_loop_vector tells us how to loop back to the beginning of each loop when
    # making a derangement from named_loops. Updating this ONCE when the loop_lengths change makes
    # getting the next derangement easier.
    @loop_vector = n.times.map { |num| num + 1 }
    index_to_change = -1
    loop_lengths.each do |length|
      index_to_change += length
      @loop_vector[index_to_change] -= length
    end
  end

  def reset_parameter_limits
    @parameter_limits = ((n - 1).times.map { |num| (n - 1) - num }).unshift(1)
  end

  def reset_parameter_values
    @parameter_values = Array.new(n, 1)
  end

  def reset_named_loops
    @named_loops = n.times.map { |num| num + 1 }
  end
    
  def reset_change_from_index
    @change_from_index = variables[-1]
  end
    
  def reset_remaining_named_loop_values
    @remaining_named_loop_values = n.times.map { |num| num + 1 }
  end

  def set_memo_hash
    @memo_hash = Hash.new()
    @variables.each do |variable|
      @memo_hash[variable] = named_loops[variable..-1].clone.sort
    end
  end

  def output_derangement
    outputter.add_perm_to_output(derangement)
  end
end