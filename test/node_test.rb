require 'minitest'

class NodeTest < Minitest::Test
  def setup
    @node = Node.new
  end

  def test_can_create_an_instance
    assert_instance_of Node, @node
  end
end
