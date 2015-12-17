require 'minitest'
require 'test_helper'
require 'node'
require 'complete_me'
require 'pry'

class NodeTest < Minitest::Test
  attr_accessor :node, :completion

  def setup
    @node = Node.new
  end

  def test_can_create_an_instance
    assert_instance_of Node, node
  end

  def test_has_an_initial_value_set_to_an_empty_string
    assert_equal "", node.value
  end

  def test_can_be_instantiated_with_a_value
    node = Node.new("apple")

    assert_equal "apple", node.value
  end

  def test_has_an_initial_word_set_to_false
    refute node.word?
  end

  def test_can_set_word_to_true_on_initialize
    node = Node.new("a", true)

    assert node.word?
  end

  def test_has_an_initial_children_hash
    assert_instance_of Hash, node.children
  end

  def test_has_an_initial_children_hash_that_is_empty
    assert node.children.empty?
  end

  def test_has_a_weight_set_to_a_hash_on_assignment
    assert_instance_of Hash, node.weight
  end
end

class NodeInternalsTest < Minitest::Test
  attr_reader :node

  def setup
    @node = Node.new
  end

  def test_can_increase_its_weight_by_an_interval_of_one
    node.increase_weight("a")

    assert_equal 1, node.weight["a"]
  end

  def test_can_have_multiple_weights_pointing_to_specific_substrings
    node.increase_weight("app")
    node.increase_weight("app")
    node.increase_weight("a")

    assert_equal 2, node.weight["app"]
    assert_equal 1, node.weight["a"]
  end

  def test_set_value_properly_sets_the_value_attribute
    node.set_value("Bubbles")

    assert_equal "Bubbles", node.value
  end

  def test_set_to_word_properly_sets_the_word_attribute
    node.set_to_word

    assert node.word?
  end
end
