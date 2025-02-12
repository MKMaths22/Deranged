class Outputter
  
  attr_accessor :output_line, :output_line_length, :output_file
  attr_reader :output_per_line, :total_outputs
  
  def initialize(output_per_line = 5)
    @output_per_line = output_per_line
    @output_line = ''
    @output_line_length = 0
    @output_file = File.exist?("output.txt") ? wipe_output : create_output_file
    @total_outputs = 0
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
    if output_line_full?
      output_current_line
      clear_current_line
    end
    @output_line = output_line.concat(array.to_s.concat(', '))
    increment_line_length
    increment_total_outputs
  end

  def increment_line_length
    @output_line_length += 1
  end

  def increment_total_outputs
    @total_outputs += 1
  end

  def finish_output
    put_stop_on_line
    output_current_line
  end

  def put_stop_on_line
    @output_line = output_line.delete_suffix(', ').concat('.')
  end
end