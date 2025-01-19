class Outputter
  def initialize
    @output_per_line = 5
    @current_output_line = ''
    @previous_output_line = ''
    @output_file = File.exist?("output.txt") ? wipe_output : create_output_file
  end

  def wipe_output
    open("output.txt", File::TRUNC) {}
    File.open("output.txt", "w")
  end

  def create_output_file
    File.new "output.txt", "w"
  end

  def add_perm_to_output(array)
    @output_file.write(array.to_s.concat(', '))
  end
end