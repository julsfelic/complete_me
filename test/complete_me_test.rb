require 'minitest'
require 'test_helper'
require 'complete_me'
require 'node'

class CompleteMeTest < Minitest::Test
  attr_accessor :completion

  def setup
    @completion = CompleteMe.new
  end

  def test_can_create_an_instance
    assert_instance_of CompleteMe, completion
  end

  def test_has_a_root_that_points_to_a_node
    assert_instance_of Node, completion.root
  end

  def test_root_node_has_a_value_of_a_empty_string
    assert_equal "", completion.root.value
  end

  def test_insert_raises_error_if_not_given_a_string
    assert_raises ArgumentError do
      completion.insert(8)
    end
  end

  def test_insert_adds_single_character_to_roots_children_that_points_to_a_node
    completion.insert('a')

    assert_instance_of Node, completion.root.children['a']
  end

  def test_insert_properly_sets_value_for_inserted_node_when_given_a_single_character
    completion.insert('a')
    inserted_node_value = completion.root.children['a'].value

    assert_equal 'a', inserted_node_value
  end

  def test_sets_word_attr_to_true_for_newly_inserted_word_that_has_one_char
    completion.insert('a')
    inserted_node = completion.root.children['a']

    assert inserted_node.word?
  end

  def test_insert_properly_inserts_a_word_of_length_2
    completion.insert('at')
    first_inserted_node  = completion.root.children['a']
    second_inserted_node = first_inserted_node.children['t']

    assert_equal 'at', second_inserted_node.value
  end

  def test_count_returns_zero_if_no_words_are_in_the_trie
    assert_equal 0, completion.count
  end

  def test_count_returns_one_if_one_word_is_in_the_trie
    completion.insert('cat')

    assert_equal 1, completion.count
  end

  def test_count_returns_two_if_two_words_are_in_the_trie
    completion.insert('cat')
    completion.insert('dog')

    assert_equal 2, completion.count
  end

  def test_the_words_cat_and_catty_count_as_two_words
    completion.insert('cat')
    completion.insert('catty')

    assert_equal 2, completion.count
  end

  def test_suggest_returns_an_empty_array_if_there_are_no_words_in_trie
    assert_equal [], completion.suggest("piz")
  end

  def test_suggest_returns_an_array_with_one_element_that_could_match_pizza
    completion.insert('pizza')
    suggestion = completion.suggest("piz")

    assert_equal ['pizza'], suggestion
  end

  def test_suggest_returns_an_array_with_two_elements_that_could_match_pizza
    completion.insert('pizza')
    completion.insert('pizzeria')
    suggestion = completion.suggest("piz")

    assert_equal ['pizza', 'pizzeria'], suggestion
  end

  def test_suggest_returns_an_sorted_array_of_suggested_words
    completion.insert('a')
    completion.insert('apple')
    completion.insert("aardvark")
    suggestion = completion.suggest("a")

    assert_equal ['a', 'aardvark', 'apple'], suggestion
  end

  def test_can_suggest_how_to_order_words
    completion.insert('pizza')
    completion.insert('pizzeria')
    completion.insert('pizzicato')
    words_before_suggest = ['pizza', 'pizzeria', 'pizzicato']

    assert_equal words_before_suggest, completion.suggest('piz')

    completion.select('piz', 'pizzeria')
    words_after_suggest = ['pizzeria', 'pizza', 'pizzicato']

    assert_equal words_after_suggest, completion.suggest('piz')
  end

  def test_selection_is_only_counted_toward_subsequent_suggestions_against_the_same_substring
    completion.insert('pizza')
    completion.insert('pizzeria')
    completion.insert('pizzicato')

    completion.select('piz', 'pizzeria')
    completion.select('piz', 'pizzeria')
    completion.select('piz', 'pizzeria')

    completion.select('pi', 'pizza')
    completion.select('pi', 'pizza')
    completion.select('pi', 'pizzicato')

    piz_suggestions = ['pizzeria', 'pizza', 'pizzicato']
    assert_equal piz_suggestions, completion.suggest("piz")

    pi_suggestions = ['pizza', 'pizzicato', 'pizzeria']
    assert_equal pi_suggestions, completion.suggest("pi")
  end

  def test_populate_properly_parses_file_and_inserts_words_into_trie
    dictionary = File.read("./test/medium.txt")
    completion.populate(dictionary)

    assert_equal 1000, @completion.count
  end
end

class CompleteMeInternalsTest < Minitest::Test
  attr_accessor :completion

  def setup
    @completion = CompleteMe.new
  end

  def test_insert_word_properly_sets_word_when_node_doesnt_exist
    completion.insert_word('a')
    word_node = completion.root.children['a']

    assert word_node.word?
  end

  def test_insert_word_properly_sets_word_when_node_doesnt_exist
    completion.insert_word('apple')
    word_node = completion.root.children['a']

    refute word_node.word?

    completion.insert_word('a')
    word_node = completion.root.children['a']

    assert word_node.word?
  end

  def test_insert_word_can_add_multiple_words_that_share_similar_characters
    completion.insert_word('a')
    completion.insert_word('apple')
    completion.insert_word('aardvark')

    assert_equal ['a', 'aardvark', 'apple'], completion.suggest('a')
  end

  def test_set_node_to_a_word_properly_sets_value_and_word_switch
    node = Node.new

    completion.set_node_to_a_word(node, "julian")

    assert_equal "julian", node.value
    assert node.word?
  end

  def test_create_word_returns_node_with_word_switch_to_true
    node = completion.create_word("julian")

    assert_instance_of Node, node
    assert_equal "julian", node.value
    assert node.word?
  end

  def test_connect_node_properly_connects_two_nodes
    node1 = Node.new
    node2 = Node.new

    completion.connect_node(node1, node2, "j")

    assert_equal node2.object_id, node1.children["j"].object_id
  end

  def test_total_count_of_words_returns_proper_count
    completion.insert('a')
    completion.insert('aardvark')
    completion.insert('apple')

    assert_equal 3, completion.total_count_of_words
  end

  def test_sort_words_properly_sorts_words
    node1 = Node.new("apple", true)
    node2 = Node.new("aardvark", true)
    node3 = Node.new("awesome", true)

    unsorted_nodes = [node1, node2, node3]

    sorted_words = ["aardvark", "apple", "awesome"]

    assert_equal sorted_words, completion.sort_words(unsorted_nodes, "a")
  end

  def test_sort_words_properly_sorts_words_with_weights_and_without
    node1 = Node.new("apple", true)
    node1.increase_weight("a")
    node1.increase_weight("a")
    node1.increase_weight("a")
    node2 = Node.new("aardvark")
    node2.increase_weight("a")
    node2.increase_weight("a")
    node3 = Node.new("awesome")
    node3.increase_weight("a")
    node4 = Node.new("alright")
    node5 = Node.new("always")
    node6 = Node.new("ant")

    unsorted_nodes = [node1, node2, node3, node4, node5, node6]

    sorted_words = ["apple", "aardvark", "awesome", "alright", "always", "ant"]

    assert_equal sorted_words, completion.sort_words(unsorted_nodes, "a")
  end
end
