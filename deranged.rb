class Derangements

  require_relative './outputter'
  require_relative './permutations'
  require_relative './loops'
  
  MAX_TRIES = 5
  
  attr_reader :max_input, :output
  
  def initialize(max_input = 11, number = nil, method = nil)
    puts "Welcome."
    @max_input = max_input
    number = get_valid_number unless number
      if number
        method = get_method unless method
        @calculator = 
          method == 'permutations' ? FromPermutations.new(number) : ConstructLoops.new(number)
          @start_time = Time.now
          @calculator.calculate_derangements
        puts "Time taken = #{Time.now - @start_time} seconds."
      end
  end

  def get_valid_number
    input_so_far = 0
      MAX_TRIES.times do
        puts request_input_number
        input_so_far = gets.strip.to_i
        return input_so_far if valid?(input_so_far)
        puts input_error_message
      end
    puts no_input_message
    nil
  end

  def get_method
    puts request_method
    unless gets.strip.chr.downcase == 'c'
      puts states_permutations
      return 'permutations'
    end
    puts states_loops
    return 'loops'
  end

  def states_permutations
    'You have chosen to sort derangements from permutations. Calculating...'
  end

  def states_loops
    'You have chosen to construct derangements from loops. Calculating...'
  end

  def valid?(input)
    (1 <= input) && (input <= max_input)
  end

  def request_method
    "Please enter P to sort derangements from permutations, or C to construct the derangements from loops."
  end
  
  def request_input_number
    "Please enter a positive integer no larger than #{max_input}."
  end

  def input_error_message
    "That was not acceptable."
  end

  def no_input_message
    "No valid input after #{MAX_TRIES} attempts. Program terminated. Have a nice day."
  end
end 

Derangements.new