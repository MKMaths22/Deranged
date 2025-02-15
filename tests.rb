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

end