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

  def test_root_node_has_a_value_of_a_empty_string
    assert_equal "", @completion.root.value
  end

  def test_insert_raises_error_if_not_given_a_string
    assert_raises ArgumentError do
      @completion.insert(8)
    end
  end

  def test_insert_adds_single_character_to_root_node_that_points_to_a_node
    @completion.insert('a')

    assert_instance_of Node, @completion.root.children['a']
  end
end
