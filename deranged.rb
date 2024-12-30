class Derangements
  
  MAX_TRIES = 5
  
  attr_reader :max_input, :value_of_n, :output
  
  def initialize(max_input = 11)
    puts "Welcome."
    @max_input = max_input
    @value_of_n = get_valid_input
    @output = []
    calculate_derangements if @value_of_n
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
    puts "Dummy text to show derangements being calculated."
    @output = [[2, 3, 1], [3, 1, 2]]
    create_output_file unless File.exist?("output.txt")
    write_output
  end

  def create_output_file
    File.new "output.txt", "w"
  end

  def write_output
    File.write("output.txt", output)
  end
end

Derangements.new