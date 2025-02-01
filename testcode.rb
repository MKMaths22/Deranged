def loop_vector(current_loop_lengths, n)
    # the current_loop_vector tells us how to loop back to the beginning of each loop when
    # making a derangement from named_loops. Updating this ONCE when the loop_lengths change makes
    # getting the next derangement easier.
    current_loop_vector = n.times.map { |num| num + 1 }
    index_to_change = -1
    current_loop_lengths.each do |length|
      index_to_change += length
      current_loop_vector[index_to_change] -= length
    end
    current_loop_vector
end

def generate_initial_derangement(current_loop_lengths, n)
    current_loop_vector = loop_vector(current_loop_lengths, n)
    current_named_loops = n.times.map { |num| num + 1 }
    current_derangement = Array.new(n, 0)
    current_named_loops.each_with_index do |value, index|
      current_derangement[value - 1] = current_named_loops[current_loop_vector[index]]
    end
    current_derangement
end

# puts generate_initial_derangement([3,4,2], 9)

current_named_loops = [6,5,4,3,2,1]
puts current_named_loops[4..-1]
puts "/n"
puts current_named_loops

