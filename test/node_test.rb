require 'minitest'
require 'test_helper'
require 'node'

class NodeTest < Minitest::Test
  def setup
    @node = Node.new
  end

  def test_can_create_an_instance
    assert_instance_of Node, @node
  end

  def test_has_an_initial_value_attr_set_to_an_empty_string
    assert_equal "", @node.value
  end

  def test_value_can_be_instantiated_with_a_value
    node = Node.new("a")

    assert_equal "a", node.value
  end

  def test_word_can_be_instantiated_with_a_value
    node = Node.new("a", true)

    assert node.word?
  end

  def test_has_an_initial_children_attr_set_to_an_empty_hash
    assert_instance_of Hash, @node.children
  end

  def test_has_an_initial_word_attr_set_to_false
    refute @node.word?
  end

  def test_has_a_weight_set_to_zero_on_assignment
    assert_equal 0, @node.weight
  end

  def test_can_increase_its_weight_by_an_interval_of_one
    @node.increase_weight

    assert_equal 1, @node.weight
  end
end
