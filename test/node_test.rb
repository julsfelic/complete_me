require 'minitest'

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

  def test_has_a_children_attr_set_to_an_empty_hash
    assert_instance_of Hash, @node.children
  end
end
