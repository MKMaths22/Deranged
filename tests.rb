require './deranged'
require './permutations'
require './loops.rb'
require 'minitest/autorun'
# require './loopsnomemory.rb'

class DerangementsTest < Minitest::Test
  def setup
    @five_with_loops = Derangements.new(11, 5, 'loops')
  end

  def test_number_of_outputs
    output_handler = @five_with_loops.calculator.outputter
    assert_equal(output_handler.total_outputs, 44, 'did not return correct number of derangements')
  end

end