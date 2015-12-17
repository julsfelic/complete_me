require 'minitest'
require 'test_helper'
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

  def test_insert_adds_single_character_to_roots_children_that_points_to_a_node
    @completion.insert('a')

    assert_instance_of Node, @completion.root.children['a']
  end

  def test_insert_properly_sets_value_for_inserted_node_when_given_a_single_character
    @completion.insert('a')
    inserted_node_value = @completion.root.children['a'].value

    assert_equal 'a', inserted_node_value
  end

  def test_sets_word_attr_to_true_for_newly_inserted_word_that_has_one_char
    @completion.insert('a')
    inserted_node = @completion.root.children['a']

    assert inserted_node.word?
  end

  def test_insert_properly_inserts_a_word_of_length_2
    @completion.insert('at')
    first_inserted_node  = @completion.root.children['a']
    second_inserted_node = first_inserted_node.children['t']

    assert_equal 'at', second_inserted_node.value
  end

  def test_count_returns_zero_if_no_words_are_in_the_trie
    assert_equal 0, @completion.count
  end

  def test_count_returns_one_if_one_word_is_in_the_trie
    @completion.insert('cat')

    assert_equal 1, @completion.count
  end

  def test_count_returns_two_if_two_words_are_in_the_trie
    @completion.insert('cat')
    @completion.insert('dog')

    assert_equal 2, @completion.count
  end

  def test_the_words_cat_and_catty_count_as_two_words
    @completion.insert('cat')
    @completion.insert('catty')

    assert_equal 2, @completion.count
  end

  def test_suggest_returns_an_empty_array_if_there_are_no_words_in_trie
    assert_equal [], @completion.suggest("piz")
  end

  def test_suggest_returns_an_array_with_one_element_that_could_match_pizza
    @completion.insert('pizza')
    suggestion = @completion.suggest("piz")

    assert_equal ['pizza'], suggestion
  end

  def test_suggest_returns_an_array_with_two_elements_that_could_match_pizza
    @completion.insert('pizza')
    @completion.insert('pizzeria')
    suggestion = @completion.suggest("piz")

    assert_equal ['pizza', 'pizzeria'], suggestion
  end

  def test_suggest_returns_an_sorted_array_of_suggested_words
    @completion.insert('a')
    @completion.insert('apple')
    @completion.insert("aardvark")
    suggestion = @completion.suggest("a")

    assert_equal ['a', 'aardvark', 'apple'], suggestion
  end

  def test_can_suggest_how_to_order_words
    @completion.insert('pizza')
    @completion.insert('pizzeria')
    @completion.insert('pizzicato')
    words_before_suggest = ['pizza', 'pizzeria', 'pizzicato']

    assert_equal words_before_suggest, @completion.suggest('piz')

    @completion.select('piz', 'pizzeria')
    words_after_suggest = ['pizzeria', 'pizza', 'pizzicato']

    assert_equal words_after_suggest, @completion.suggest('piz')
  end
  meta t: true
  def test_selection_is_only_counted_toward_subsequent_suggestions_against_the_same_substring
    @completion.insert('pizza')
    @completion.insert('pizzeria')
    @completion.insert('pizzicato')

    @completion.select('piz', 'pizzeria')
    @completion.select('piz', 'pizzeria')
    @completion.select('piz', 'pizzeria')

    @completion.select('pi', 'pizza')
    @completion.select('pi', 'pizza')
    @completion.select('pi', 'pizzicato')

    piz_suggestions = ['pizzeria', 'pizza', 'pizzicato']
    assert_equal piz_suggestions, @completion.suggest("piz")

    pi_suggestions = ['pizza', 'pizzicato', 'pizzeria']
    assert_equal pi_suggestions, @completion.suggest("pi")
  end
  # create a personal dictionary file with 100 words that we could run on travis

  # def test_populate_properly_parses_file_and_inserts_words_into_trie
  #   dictionary = File.read("/usr/share/dict/words")
  #   @completion.populate(dictionary)
  #
  #   assert_equal 235886, @completion.count
  # end
end
