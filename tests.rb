require './deranged'
require './permutations'
require './loops.rb'
require 'minitest/autorun'
# require './loopsnomemory.rb'

class DerangementsTest < Minitest::Test
  def setup
    deranged = Derangements.new
    
  end

  def test_truth
    assert_equal(6, 6, 'Failed to make six equal six')
  end

end