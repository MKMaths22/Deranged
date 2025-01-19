class Outputter
  
  attr_accessor :current_output_line, :current_output_line_length, :output_file
  attr_reader :output_per_line
  
  def initialize(output_per_line = 5)
    @output_per_line = output_per_line
    @current_output_line = ''
    @current_output_line_length = 0
    @output_file = File.exist?("output.txt") ? wipe_output : create_output_file
  end

  def wipe_output
    open("output.txt", File::TRUNC) {}
    File.open("output.txt", "w")
  end

  def output_current_line
    @output_file.write(current_output_line.concat("\n"))
  end

  def current_output_line_full?
    @current_output_line_length == @output_per_line
  end

  def clear_current_line
    @current_output_line = ''
    @current_output_line_length = 0
  end

  def create_output_file
    File.new "output.txt", "w"
  end

  def add_perm_to_output(array)
    if current_output_line_full?
      output_current_line
      clear_current_line
    end
    @current_output_line = current_output_line.concat(array.to_s.concat(', '))
    increment_current_line_length
  end

  def increment_current_line_length
    @current_output_line_length += 1
  end

  def finish_output
    put_stop_on_current_line
    output_current_line
  end

  def put_stop_on_current_line
    @current_output_line = current_output_line.delete_suffix(', ').concat('.')
  end
end