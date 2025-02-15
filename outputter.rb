class Outputter
  
  attr_accessor :output_line, :output_line_length, :output_file
  attr_reader :output_per_line, :testing, :aggregated_output
  
  def initialize(testing = false, output_per_line = 5)
    @testing = testing
    @output_per_line = output_per_line
    @output_line = ''
    @output_line_length = 0
    @output_file = File.exist?("output.txt") ? wipe_output : create_output_file
    @aggregated_output = [] if testing
  end

  def wipe_output
    open("output.txt", File::TRUNC) {}
    File.open("output.txt", "w")
  end

  def output_current_line
    @output_file.write(output_line.concat("\n"))
  end

  def output_line_full?
    @output_line_length == @output_per_line
  end

  def clear_current_line
    @output_line = ''
    @output_line_length = 0
  end

  def create_output_file
    File.new "output.txt", "w"
  end

  def add_perm_to_output(array)
    increment_total_outputs(array.clone) if testing
    if output_line_full?
      output_current_line
      clear_current_line
    end
    @output_line = output_line.concat(array.to_s.concat(', '))
    increment_line_length
  end

  def increment_line_length
    @output_line_length += 1
  end

  def increment_total_outputs(array)
    @aggregated_output.push(array)
  end

  def finish_output
    put_stop_on_line
    output_current_line
    @output_file.close
    sort_aggregated_output if testing
  end

  def put_stop_on_line
    @output_line = output_line.delete_suffix(', ').concat('.')
  end

  def sort_aggregated_output
    @aggregated_output = @aggregated_output.clone.sort
  end
end