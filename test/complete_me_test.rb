require 'minitest'
require 'complete_me'
require 'node'

class CompleteMeTest < Minitest::Test
  def setup
    @completion = CompleteMe.new
  end

  def test_can_create_an_instance
    assert_instance_of CompleteMe, @completion
  end

  def test_has_a_root_that_points_to_a_node
    assert_instance_of Node, @completion.root
  end
end
