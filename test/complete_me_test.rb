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

  def test_insert_properly_sets_value_for_inserted_node_when_given_a_single_character
    @completion.insert('a')
    inserted_node_value = @completion.root.children['a'].value

    assert_equal 'a', inserted_node_value
  end

  def test_sets_word_attr_to_true_for_newly_inserted_node_when_given_a_single_character
    @completion.insert('a')
    inserted_node = @completion.root.children['a']

    assert inserted_node.word?
  end

  def test_insert_properly_inserts_a_word_of_length_2
    @completion.insert('at')
    first_inserted_node  = @completion.root.children['a']
    second_inserted_node = first_inserted_node.children['t']

    assert_equal 'a', first_inserted_node.value
    assert_equal 'at', second_inserted_node.value
  end
end
