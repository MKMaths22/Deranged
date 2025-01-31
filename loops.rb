class ConstructLoops

  attr_reader :n, :current_parameter_limits, :current_loop_lengths, :loop_lengths, :current_loop_vector
  attr_accessor :current_parameter_values, :current_named_loops, :current_derangement, :current_variables, :change_from_index, :remaining_named_loop_values

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
    @change_from_index = current_variables.size - 1
    @remaining_named_loop_values = []
    # current_parameter_limits starts as [1, n - 1, n - 2 .... 1]
  end

  def calculate_derangements
    write_loop_lengths
    loop_lengths[n].each do |array|
      update_current_loop_lengths(array)
      set_parameter_limits_and_variables_etc_for_new_loop_lengths
      make_named_loops
    end
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
    update_parameter_limits
    update_variables
    reset_parameter_values
    reset_named_loops
    update_loop_vector
    reset_change_from_index
    reset_remaining_named_loop_values
    generate_initial_derangement
  end
  
  def make_named_loops
    output_derangement
    # NOT SURE WHERE OUTPUTTING THE FIRST DERANGEMENT SHOULD GO, CHECK EXACTLY WHAT enumerate_this_and_remaining does recursively
    # current_loop_lengths is for example [3, 4, 2] from which we will get all derangements of n = 9 in which the element '1' is in a loop of length 3 and the next lowest
    # element not yet chosen is in a loop of length 4 and the remaining elements make a loop of length 2.
    # the parameters are numbered in the computer-indexed way from 0 to n - 1, and correspondingly the variables, which are the parameters with limit at least 2
    # the VALUES of the parameters/variables are human-indexed, where 1 means lowest-available value etc..
    update_named_loops


    # current_parameter_limits is the array telling us how many choices we have for each member of the loops. For example, for [3, 4, 2] we get [1, 8, 7, 1, 5, 4, 3, 1, 1]
    
    # Starts with parameter values of [1, 1, 1, .... 1] and generates the next option lexicographically until we reach the upper limit for each choice.
    # But if we keep updating the parameter_values lexico and then generate the named_loops from that (and then the derangement itself trivially) then lots of steps will be repeated.
    # Can we 'save our progress' so that we ONLY UPDATE the parts that have changed from changing the parameter values? Then the earlier part of the named loops can be kept and not
    # recreated in exactly the same way.

    # Make sure parameter_limits and parameter_values are RESET AT THE END of their current use
  end

  def update_named_loops
    enumerate_this_and_remaining(0)
  end

  def enumerate_this_and_remaining(variable_index)
  # variable index goes from 0 to current_variables.size - 1, telling us which variable we are dealing from.
  # As this method recursively calls other versions of itself, it causes the variables to reach all possible combinations,
  # and therefore the parameters too (because the other parameters do not change anyway.)
    parameter_number = current_variables[variable_index]
    number_of_values_taken = current_parameter_limits[parameter_number]
    number_of_values_taken.times do |cycle|
      variable_index + 1 == current_variables.size ? modify_and_output_named_loops_and_derangement : enumerate_this_and_remaining(variable_index + 1)
      if cycle + 1 == number_of_values_taken 
        current_parameter_values[parameter_number] = 1 
      else
        current_parameter_values[parameter_number] += 1
        change_from_index = parameter_number
        remaining_named_loop_values = current_named_loops[parameter_number, -1].sort unless variable_index + 1 == current_variables.size && cycle >= 1
      end
    end
  end

  def modify_and_output_named_loops_and_derangement


  
    output_derangement
  end

  private
  
  def update_parameter_limits
    reset_parameter_limits
    index_to_change = 0
    current_loop_lengths.each do |length|
      index_to_change += length
      @current_loop_lengths[index_to_change] = 1
    end
  end

  def update_variables
    current_variables = []
    current_parameter_limits.each_with_index do | limit, parameter |
      current_variables.push(parameter) if limit >= 2
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
    @current_parameter_limits = ((n - 1).times.map { |num| (n - 1) - num }).unshift(1)
  end

  def reset_parameter_values
    @current_parameter_values = Array.new(n, 1)
  end

  def reset_named_loops
    @current_named_loops = n.times.map { |num| num + 1 }
  end
    
  def reset_change_from_index
    @change_from_index = current_variables.size - 1
  end
    
  def reset_remaining_named_loop_values
    @reset_remaining_named_loop_values = []
  end

  def generate_initial_derangement
    @current_named_loops.each_with_index do |value, index|
      @current_derangement[value - 1] = @current_named_loops[@current_loop_vector[index]]
    end
    # WE WANT TO GENERALISE THIS FOR CASES WHEN WE ARE JUST MODIFYING THE DERANGEMENT from a certain point in the named_loops onwards because of the @change_from_index 
  end
  
  def output_derangement
    outputter.add_perm_to_output(current_derangement)
  end
end