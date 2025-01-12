class Derangements
  
  MAX_TRIES = 5
  
  attr_reader :max_input, :n, :output
  
  def initialize(max_input = 11)
    puts "Welcome."
    @max_input = max_input
    @n = get_valid_input
    @output = []
    calculate_derangements if @n
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
    current_permutation = n.times.map { |num| num + 1 }
    # the first permutation is [1, 2, 3 ... n]
    while current_permutation
      @output.push(current_permutation) if is_derangement?(current_permutation)
      current_permutation = next_permutation(current_permutation)
      # if there is no next permutation, the next_permutation method returns nil, stopping the while loop
    end
    create_output_file unless File.exist?("output.txt")
    write_output
  end

  def next_permutation(permutation)
    puts "We want the next permutation after #{permutation}"
    return nil if n == 1
    available_values = Array.new(n, false)
    check_position = n - 2
    puts "check_position has value #{check_position}"
    puts "Available values starts as #{available_values}"
      while check_position > 0 && permutation[check_position] > permutation[check_position + 1]
        available_values[permutation[check_position + 1] - 1] = true
        check_position -= 1
        puts "check_position now has value #{check_position}"
      end
      available_values[permutation[check_position] - 1] = true
    return nil if check_position == 0 && permutation[check_position] == n
    # check_position is now the first place in the permutation, counting backwards from the end, that we can increase the value of for the next permutation
    # the available_values PLUS ONE (indexed from zero to n - 1) are the remaining numbers we can place in the permutation from that place onwards without duplicating the previous ones
    next_perm = permutation[0..(check_position - 1)]
    # check this line works for check_position = zero
    can_we_use = permutation[check_position] + 1
    can_we_use += 1 until available_values[can_we_use]
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

  def create_output_file
    File.new "output.txt", "w"
  end

  def write_output
    File.write("output.txt", output)
  end
end

Derangements.new