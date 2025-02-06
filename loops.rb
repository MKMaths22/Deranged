class ConstructLoops

  attr_reader :n, :current_parameter_limits, :current_loop_lengths, :loop_lengths, :current_loop_vector, :outputter
  attr_accessor :current_parameter_values, :current_named_loops, :current_derangement, :current_variables, :change_from_index, :memo_hash, :remaining_named_loop_values

  def initialize(n = 7)
    @n = n
    @outputter = Outputter.new
    @loop_lengths = Hash.new([])
    # loop_lengths will be a Hash with a key of 2, 3, ... n - 2 or n 
    @current_loop_lengths = []
    @current_parameter_values = Array.new(n, 1)
    @current_parameter_limits = ((n - 1).times.map { |num| (n - 1) - num }).unshift(1)
    @current_variables = []
    update_variables
    @current_loop_vector = []
    @current_named_loops = n.times.map { |num| num + 1 }
    @current_derangement = []
    @change_from_index = current_variables[-1]
    @remaining_named_loop_values = n.times.map { |num| num + 1 }
    @memo_hash = Hash.new()
    # current_parameter_limits starts as [1, n - 1, n - 2 .... 1]
  end

  def calculate_derangements
    write_loop_lengths
    # puts "@loop_lengths = #{loop_lengths}."
    loop_lengths[n].each do |array|
      update_current_loop_lengths(array)
      # puts "At line 29, current_loop_lengths = #{current_loop_lengths}."
      set_parameter_limits_and_variables_etc_for_new_loop_lengths
      # puts "For loop_lengths of #{current_loop_lengths}, the memo_hash starts off as #{memo_hash}."
      make_named_loops
    end
    @outputter.finish_output
  end

  def write_loop_lengths
    @loop_lengths[2] = [[2]]
    counter = 3
      while counter <= n do
        find_loop_lengths(counter) unless counter == n - 1
        counter += 1
      end
  end

  def find_loop_lengths(num)
    @loop_lengths[num] = [[num]]
    counter = 2
      while counter <= num - 2 do
        @loop_lengths[counter].each do |array|
          @loop_lengths[num].push(array.clone.push(num - counter))
        end
        counter += 1
      end
  end

  def set_parameter_limits_and_variables_etc_for_new_loop_lengths
    # puts "current_loop_lengths = #{current_loop_lengths}"
    update_parameter_limits
    update_variables
    reset_parameter_values
    reset_named_loops
    update_loop_vector
    reset_change_from_index
    reset_remaining_named_loop_values
    set_memo_hash
    modify_derangement(0)
  end
  
  def make_named_loops
    # output_derangement
    # NOT SURE WHERE OUTPUTTING THE FIRST DERANGEMENT SHOULD GO, CHECK EXACTLY WHAT enumerate_this_and_remaining does recursively
    # current_loop_lengths is for example [3, 4, 2] from which we will get all derangements of n = 9 in which the element '1' is in a loop of length 3 and the next lowest
    # element not yet chosen is in a loop of length 4 and the remaining elements make a loop of length 2.
    # the parameters are numbered in the computer-indexed way from 0 to n - 1, and correspondingly the variables, which are the parameters with limit at least 2
    # the VALUES of the parameters/variables are human-indexed, where 1 means lowest-available value etc..
    update_parameter_values_etc


    # current_parameter_limits is the array telling us how many choices we have for each member of the loops. For example, for [3, 4, 2] we get [1, 8, 7, 1, 5, 4, 3, 1, 1]
    
    # Starts with parameter values of [1, 1, 1, .... 1] and generates the next option lexicographically until we reach the upper limit for each choice.
    # But if we keep updating the parameter_values lexico and then generate the named_loops from that (and then the derangement itself trivially) then lots of steps will be repeated.
    # Can we 'save our progress' so that we ONLY UPDATE the parts that have changed from changing the parameter values? Then the earlier part of the named loops can be kept and not
    # recreated in exactly the same way.

    # Make sure parameter_limits and parameter_values are RESET AT THE END of their current use
  end

  def update_parameter_values_etc
    enumerate_this_and_remaining(0)
  end

  def enumerate_this_and_remaining(variable_index)
  # variable index goes from 0 to current_variables.size - 1, telling us which variable we are dealing from.
  # As this method recursively calls other versions of itself, it causes the variables to reach all possible combinations,
  # and therefore the parameters too (because the other parameters do not change anyway.)
  #  puts "At line 93, variable index = #{variable_index}. Current variables are #{current_variables}."
    parameter_number = current_variables[variable_index]
    number_of_values_taken = current_parameter_limits[parameter_number]
    number_of_values_taken.times do |cycle|
      if variable_index + 1 == current_variables.size
        # puts "At line 101, the current_loop_lengths are #{current_loop_lengths}. The variables are #{current_variables} and the parameters have values #{current_parameter_values}."
        modify_named_loops
        modify_derangement
        output_derangement 
      else enumerate_this_and_remaining(variable_index + 1)
      end
      if cycle + 1 == number_of_values_taken 
        current_parameter_values[parameter_number] = 1 
      else
        current_parameter_values[parameter_number] += 1
        # puts "change_from_index is #{change_from_index} before it is changed."
        @change_from_index = parameter_number
        # puts "change_from_index has changed to #{change_from_index}."
        remaining_named_loop_values = current_named_loops[parameter_number..-1].clone.sort
        memo_hash[parameter_number] = remaining_named_loop_values.clone if cycle == 0
      end
    end
  end

  def modify_named_loops(from = change_from_index)
    index = from
    remaining_named_loop_values = memo_hash[index].clone
    temporary_remaining_values = remaining_named_loop_values.clone
    # puts "On Line 120, modify_named_loops has from = #{from} and remaining_named_loop_values = #{remaining_named_loop_values}."
    # puts "modify_named_loops is running and temporary_remaining_values = #{temporary_remaining_values}."
    # the remaining values from the set (1...n), disregarding those values used before index = from in the current_named_loops
    # temp... and remaining... are sorted in increasing order, so we can take the correct values based on the parameter_values
    while index < n do
      index_to_use = current_parameter_values[index] - 1
      value_to_use = temporary_remaining_values[index_to_use]
      current_named_loops[index] = value_to_use
      temporary_remaining_values.delete_at(index_to_use)
      index += 1
    end
  end

  def modify_derangement(from = change_from_index)
    # puts "modify_derangement is running with from = #{from}. Current_named_loops = #{current_named_loops}. Loop vector is #{current_loop_vector} for loop lengths #{current_loop_lengths}. The derangement starts as #{current_derangement}."
    index = from.zero? ? 0 : from - 1
    while index < n do
      @current_derangement[current_named_loops[index] - 1] = current_named_loops[current_loop_vector[index]]
      # puts "One change with index = #{index} has changed the derangement to #{current_derangement}."
      index += 1
    end
    # puts "At the end of modify_derangement, the derangement is #{current_derangement}. The current_named_loops should not change and are #{current_named_loops}."
  end

  private
  
  def update_parameter_limits
    reset_parameter_limits
    # puts "update_parameter_limits is running and they have reset. They now equal #{current_parameter_limits}."
    index_to_change = 0
    current_loop_lengths.each do |length|
      index_to_change += length
      @current_parameter_limits[index_to_change] = 1 unless index_to_change == n
    end
  end

  def update_variables
    # puts "The update_variables method is running, with current_parameter_limits = #{current_parameter_limits}."
    current_variables = []
    current_parameter_limits.each_with_index do | limit, parameter |
    @current_variables = current_variables.push(parameter) if limit >= 2
    end
  end
  
  def update_current_loop_lengths(array)
    @current_loop_lengths = array
  end

  def update_loop_vector
    # the current_loop_vector tells us how to loop back to the beginning of each loop when
    # making a derangement from named_loops. Updating this ONCE when the loop_lengths change makes
    # getting the next derangement easier.
    @current_loop_vector = n.times.map { |num| num + 1 }
    index_to_change = -1
    current_loop_lengths.each do |length|
      index_to_change += length
      @current_loop_vector[index_to_change] -= length
    end
  end

  def reset_parameter_limits
    # puts "Before resetting, current_parameter_limits = #{current_parameter_limits}."
    @current_parameter_limits = ((n - 1).times.map { |num| (n - 1) - num }).unshift(1)
    # puts "After resetting, the limits are #{current_parameter_limits}."
  end

  def reset_parameter_values
    @current_parameter_values = Array.new(n, 1)
  end

  def reset_named_loops
    @current_named_loops = n.times.map { |num| num + 1 }
  end
    
  def reset_change_from_index
    @change_from_index = current_variables[-1]
  end
    
  def reset_remaining_named_loop_values
    @remaining_named_loop_values = n.times.map { |num| num + 1 }
  end

  def set_memo_hash
    @memo_hash = Hash.new()
    @current_variables.each do |variable|
      @memo_hash[variable] = current_named_loops[variable..-1].clone.sort
    end
  end

  # def generate_initial_derangement
  #  @current_named_loops.each_with_index do |value, index|
  #    @current_derangement[value - 1] = @current_named_loops[@current_loop_vector[index]]
  #  end
    # WE WANT TO GENERALISE THIS FOR CASES WHEN WE ARE JUST MODIFYING THE DERANGEMENT from a certain point in the named_loops onwards because of the @change_from_index 
  # end
  
  def output_derangement
    outputter.add_perm_to_output(current_derangement)
  end
end