class ConstructLoops

  attr_reader :n, :current_parameter_limits, :current_loop_lengths, :loop_lengths
  attr_accessor :current_parameter_values, :current_named_loops

  def initialize(n = 7)
    @n = n
    @outputter = Outputter.new
    @loop_lengths = Hash.new([])
    # loop_lengths will be a Hash with a key of 2, 3, ... n - 2 or n 
    @current_loop_lengths = []
    @current_parameter_values = Array.new(n, 1)
    @current_parameter_limits = ((n - 1).times.map { |num| (n - 1) - num }).unshift(1)
    @current_named_loops
    # current_parameter_limits starts as [1, n - 1, n - 2 .... 1]
  end

  def calculate_derangements
    write_loop_lengths
    # loop_lengths[n].each do |array|
    #  update_current_loop_lengths(array)
    #  make_named_loops
    puts loop_lengths[n].size
    # end
  end

  def write_loop_lengths
    # puts "write_loop_lengths is running"
    @loop_lengths[2] = [[2]]
    counter = 3
      while counter <= n do
        # puts "counter in write_loop_lengths = #{counter}."
        find_loop_lengths(counter) unless counter == n - 1
        counter += 1
        # puts "counter in write_loop_lengths now incremented to #{counter}."
      end
  end

  def find_loop_lengths(num)
    # puts "find_loop_lengths running with num = #{num}."
    @loop_lengths[num] = [[num]]
    counter = 2
      while counter <= num - 2 do
        @loop_lengths[counter].each do |array|
          @loop_lengths[num].push(array.clone.push(num - counter))
          # puts "After push stage with counter = #{counter} and num = #{num}, loop_lengths = #{loop_lengths}."
        end
        counter += 1
      end
  end

  def make_named_loops
    # current_loop_lengths is for example [3, 4, 2] from which we will get all derangements of n = 9 in which the element '1' is in a loop of length 3 and the next lowest
    # element not yet chosen is in a loop of length 4 and the remaining elements make a loop of length 2.
    update_parameter_limits
    update_named_loops


    # current_parameter_limits is the array telling us how many choices we have for each member of the loops. For example, for [3, 4, 2] we get [1, 8, 7, 1, 5, 4, 3, 1, 1]
    
    # Starts with parameter values of [1, 1, 1, .... 1] and generates the next option lexicographically until we reach the upper limit for each choice.
    # But if we keep updating the parameter_values lexico and then generate the named_loops from that (and then the derangement itself trivially) then lots of steps will be repeated.
    # Can we 'save our progress' so that we ONLY UPDATE the parts that have changed from changing the parameter values? Then the earlier part of the named loops can be kept and not
    # recreated in exactly the same way.

    # Make sure parameter_limits and parameter_values are RESET AT THE END of their current use
  end

  private
  
  def update_parameter_limits
    # assumes we have just reset the parameter limits from the previous current_loop_lengths.
    index_to_change = 0
    current_loop_lengths.each do |length|
      index_to_change += length
      @current_loop_lengths[index_to_change] = 1
    end
  end
  
  def update_current_loop_lengths(array)
    @current_loop_lengths = array
  end

  def reset_parameter_limits
    @current_parameter_limits = ((n - 1).times.map { |num| (n - 1) - num }).unshift(1)
  end

  def reset_parameter_values
    @current_parameter_values = Array.new(n, 1)
  end
end