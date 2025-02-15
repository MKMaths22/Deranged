require './deranged'
require './permutations'
require './loops.rb'
require 'minitest/autorun'
# require './loopsnomemory.rb'

class DerangementsTest < Minitest::Test

  def test_actual_derangements_for_loops
    five_with_loops = Derangements.new(11, 5, 'loops', true)
    output_handler = five_with_loops.calculator.outputter
    assert_equal(output_handler.aggregated_output, [[2, 1, 4, 5, 3], [2, 1, 5, 3, 4], [2, 3, 1, 5, 4], [2, 3, 4, 5, 1], [2, 3, 5, 1, 4], [2, 4, 1, 5, 3], [2, 4, 5, 1, 3], [2, 4, 5, 3, 1], [2, 5, 1, 3, 4], [2, 5, 4, 1, 3], [2, 5, 4, 3, 1], [3, 1, 2, 5, 4], [3, 1, 4, 5, 2], [3, 1, 5, 2, 4], [3, 4, 1, 5, 2], [3, 4, 2, 5, 1], [3, 4, 5, 1, 2], [3, 4, 5, 2, 1], [3, 5, 1, 2, 4], [3, 5, 2, 1, 4], [3, 5, 4, 1, 2], [3, 5, 4, 2, 1], [4, 1, 2, 5, 3], [4, 1, 5, 2, 3], [4, 1, 5, 3, 2], [4, 3, 1, 5, 2], [4, 3, 2, 5, 1], [4, 3, 5, 1, 2], [4, 3, 5, 2, 1], [4, 5, 1, 2, 3], [4, 5, 1, 3, 2], [4, 5, 2, 1, 3], [4, 5, 2, 3, 1], [5, 1, 2, 3, 4], [5, 1, 4, 2, 3], [5, 1, 4, 3, 2], [5, 3, 1, 2, 4], [5, 3, 2, 1, 4], [5, 3, 4, 1, 2], [5, 3, 4, 2, 1], [5, 4, 1, 2, 3], [5, 4, 1, 3, 2], [5, 4, 2, 1, 3], [5, 4, 2, 3, 1]], 'did not feed correct derangements to outputter')
  end

  def test_actual_derangements_for_permutations
    five_with_loops = Derangements.new(11, 5, 'permutations', true)
    output_handler = five_with_loops.calculator.outputter
    assert_equal(output_handler.aggregated_output, [[2, 1, 4, 5, 3], [2, 1, 5, 3, 4], [2, 3, 1, 5, 4], [2, 3, 4, 5, 1], [2, 3, 5, 1, 4], [2, 4, 1, 5, 3], [2, 4, 5, 1, 3], [2, 4, 5, 3, 1], [2, 5, 1, 3, 4], [2, 5, 4, 1, 3], [2, 5, 4, 3, 1], [3, 1, 2, 5, 4], [3, 1, 4, 5, 2], [3, 1, 5, 2, 4], [3, 4, 1, 5, 2], [3, 4, 2, 5, 1], [3, 4, 5, 1, 2], [3, 4, 5, 2, 1], [3, 5, 1, 2, 4], [3, 5, 2, 1, 4], [3, 5, 4, 1, 2], [3, 5, 4, 2, 1], [4, 1, 2, 5, 3], [4, 1, 5, 2, 3], [4, 1, 5, 3, 2], [4, 3, 1, 5, 2], [4, 3, 2, 5, 1], [4, 3, 5, 1, 2], [4, 3, 5, 2, 1], [4, 5, 1, 2, 3], [4, 5, 1, 3, 2], [4, 5, 2, 1, 3], [4, 5, 2, 3, 1], [5, 1, 2, 3, 4], [5, 1, 4, 2, 3], [5, 1, 4, 3, 2], [5, 3, 1, 2, 4], [5, 3, 2, 1, 4], [5, 3, 4, 1, 2], [5, 3, 4, 2, 1], [5, 4, 1, 2, 3], [5, 4, 1, 3, 2], [5, 4, 2, 1, 3], [5, 4, 2, 3, 1]], 'did not feed correct derangements to outputter')
  end

  def test_spot_derangements_for_larger_n
    eight_with_loops = Derangements.new(11, 8, 'loops', true)
    output_handler = eight_with_loops.calculator.outputter
    assert_equal(output_handler.aggregated_output[99], [2, 1, 5, 8, 6, 4, 3, 7])
  end

  def test_outputter_creates_output_file
    File.delete("output.txt") if File.exists?("output.txt")
    output_handler = Outputter.new()
    assert(File.exists?("output.txt"), 'output file does not exist')
  end

  def test_outputter_makes_correctly_formatted_output
    File.delete("output.txt") if File.exists?("output.txt")
    output_handler = Outputter.new(false, 1)
    output_handler.add_perm_to_output([0, 0, 0, 1])
    output_handler.add_perm_to_output([0, 0, 0, 2])
    output_handler.add_perm_to_output([0, 0, 0, 3])
    output_handler.add_perm_to_output([0, 0, 0, 4])
    output_handler.add_perm_to_output([0, 0, 0, 5])
    output_handler.add_perm_to_output([0, 0, 0, 6])
    output_handler.add_perm_to_output([0, 0, 0, 7])
    output_handler.add_perm_to_output([0, 0, 0, 8])
    output_handler.add_perm_to_output([0, 0, 0, 9])
    output_handler.add_perm_to_output([0, 0, 0, 10])
    output_handler.add_perm_to_output([0, 0, 0, 11])
    output_handler.finish_output
    first_output_line = File.readlines("output.txt").first
    assert_equal(first_output_line, '[0, 0, 0, 1],')
  end

end