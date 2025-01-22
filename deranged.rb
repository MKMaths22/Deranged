class Derangements

  require_relative './outputter'
  require_relative './calculator'
  
  MAX_TRIES = 5
  
  attr_reader :max_input, :output
  
  def initialize(max_input = 11)
    puts "Welcome."
    @max_input = max_input
    valid_input = get_valid_input
      if valid_input
        @calculator = Calculator.new(valid_input)
        @start_time = Time.now
        @calculator.calculate_derangements
        puts "Time taken = #{Time.now - @start_time} seconds."
      end
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
end 

Derangements.new