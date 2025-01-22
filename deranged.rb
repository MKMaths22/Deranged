class Derangements

  require_relative './outputter'
  
  MAX_TRIES = 5
  
  attr_reader :max_input, :n, :output
  attr_accessor :current_permutation, :current_positions
  
  def initialize(max_input = 11)
    puts "Welcome."
    @max_input = max_input
    @outputter = Outputter.new
    @n = get_valid_input
      if @n
        @current_permutation = n.times.map { |num| num + 1 }
        @current_positions = n.times.map { |num| num + 1 }
        @start_time = Time.now
        calculate_derangements
      end
    puts "Time taken = #{Time.now - @start_time} seconds."
    # the first permutation is [1, 2, 3 ... n]
    # current_positions is written using human-indexing (not computer) to say 1 in is in position 1, 2 is in position 2, etc..
  end

  def get_valid_input
    input_so_far = 0
      MAX_TRIES.times do
        puts request_input
        input_so_far = gets.strip.to_i
        return input_so_far if valid?(input_so_far)
        puts input_error_message
      end
    puts no_input_message
    nil
  end

  def valid?(input)
    (1 <= input) && (input <= max_input)
  end

  def request_input
    "Please enter a positive integer no larger than #{max_input}."
  end

  def input_error_message
    "That was not acceptable."
  end

  def no_input_message
    "No valid input after #{MAX_TRIES} attempts. Program terminated. Have a nice day."
  end

  def calculate_derangements
    while current_permutation do
      @outputter.add_perm_to_output(current_permutation) if is_derangement?(current_permutation)
      find_next_permutation
      # if there is no next permutation, @current_permutation becomes nil, stopping the while loop
    end
    @outputter.finish_output
  end

  def find_next_permutation
    looking_for = 1
      while looking_for < n && current_positions[looking_for - 1] + looking_for == (n + 1) do
        looking_for += 1
      end
      # looking_for is the highest number k such that the permutation finishes with k - 1, k - 2, k - 3 .... 1. So if
      # looking_for is at least n, we are at the final permutation n, n - 1, n - 2 .... 1.
      # The next permutation will be obtained by moving looking_for one place to the right and putting all lower values
      # at the start of the permutation in increasing order
      if looking_for == n
        @current_permutation = nil
        return
      end
    (looking_for - 1).times do |num|
      @current_permutation.pop
      @current_positions[num] = num + 1
      # we remove the first looking_for - 1 values from the end and prepare current_positions for adding them at the start
    end
    putting_it_up_front = looking_for - 1
      while putting_it_up_front > 0 do
        @current_permutation = @current_permutation.unshift(putting_it_up_front)
        # now the current_permutation has the looking_for - 1 values added to the start in increasing order
        putting_it_up_front -= 1
      end
      changing_positions = looking_for
      while changing_positions <= n do
        @current_positions[changing_positions - 1] += looking_for - 1
        # the current_positions from looking_for upwards all have to increase because we inserted looking_for - 1 values to their left
        changing_positions += 1
      end
    shift_one_step(looking_for)
    # now we shift the value looking_for one place to the right in the permutation
  end

  def shift_one_step(number)
    next_number_along_in_permutation = current_permutation[current_positions[number - 1]]
    # next_number_along... is the adjacent value to the right of looking_for
    @current_permutation[current_positions[number - 1] - 1] = next_number_along_in_permutation
    @current_permutation[current_positions[number - 1]] = number
    @current_positions[next_number_along_in_permutation - 1] = current_positions[next_number_along_in_permutation - 1] - 1
    @current_positions[number - 1] = current_positions[number - 1] + 1
    # the values looking_for and next_number_along have been interchanged, affecting current_permutation and current_positions accordingly.
  end

  def next_permutation_old_version(permutation)
    return nil if n == 1
    available_values = Array.new(n, false)
    @check_position = n - 2
    available_values[permutation[n - 1] - 1] = true
      while check_position > 0 && permutation[check_position] > permutation[check_position + 1] do
        available_values[permutation[check_position] - 1] = true
        @check_position -= 1
      end
      available_values[permutation[check_position] - 1] = true
    return nil if check_position == 0 && permutation[check_position] == n
    # check_position is now the first place in the permutation, counting backwards from the end, that we can increase the value of for the next permutation
    # the available_values PLUS ONE (indexed from zero to n - 1) are the remaining numbers we can place in the permutation from that place onwards without duplicating the previous ones
    next_perm = check_position.zero? ? [] : permutation[0..(check_position - 1)]
    can_we_use = permutation[check_position]
    until available_values[can_we_use] == true do
      can_we_use += 1
    end
    next_perm.push(can_we_use + 1)
    available_values[can_we_use] = false
    # now we use the remaining available values in increasing order
    available_values.each_with_index do | boolean, index |
      next_perm.push(index + 1) if boolean
    end
    return next_perm
  end

  def is_derangement?(array)
    array.each_with_index do |num, index|
      return false if num == index + 1
    end
    true
  end
end

Derangements.new