require './deranged'
require './permutations'
require './loops.rb'
require 'minitest/autorun'
# require './loopsnomemory.rb'

class DerangementsTest < Minitest::Test
  def setup
    # @five_with_loops = Derangements.new(11, 5, 'loops', true)
    # the Boolean at the end tells the Derangements class that we are in 'testing' mode, so that the Outputter class will
    # take care of counting and aggregating the derangements fed into it
  end

  def test_number_of_outputs_for_loops
    five_with_loops = Derangements.new(11, 5, 'loops', true)
    # the Boolean at the end tells the Derangements class that we are in 'testing' mode, so that the Outputter class will
    # take care of counting and aggregating the derangements fed into it
    output_handler = five_with_loops.calculator.outputter
    assert_equal(output_handler.total_outputs, 44, 'did not return correct number of derangements')
  end

  def test_number_of_outputs_for_permutations
    five_with_loops = Derangements.new(11, 5, 'permutations', true)
    # the Boolean at the end tells the Derangements class that we are in 'testing' mode, so that the Outputter class will
    # take care of counting and aggregating the derangements fed into it
    output_handler = five_with_loops.calculator.outputter
    assert_equal(output_handler.total_outputs, 44, 'did not return correct number of derangements')
  end

end