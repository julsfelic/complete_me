require_relative 'node'
require 'pry'

class CompleteMe
  attr_reader :root

  def initialize
    @root = Node.new
  end

  def insert(word)
    raise ArgumentError, 'Argument is not a word' unless word.is_a?(String)
    insert_word(word)
  end

  def insert_word(word, node=root, value="")
    until word.empty?
      character = word.slice!(0...1)
      value += character
      if word.empty?
        add_word_to_trie(node, character, value)
      else
        continue_through_trie(node, character, value, word)
      end
    end
  end

  def add_word_to_trie(node, character, value)
    if node.children[character].nil?
      next_node = create_word(value)
      connect_node(node, next_node, character)
    else
      set_node_to_a_word(node.children[character], value)
    end
  end

  def continue_through_trie(node, character, value, word)
    if node.children[character].nil?
      next_node = Node.new
      connect_node(node, next_node, character)
      insert_word(word, next_node, value)
    else
      next_node = node.children[character]
      insert_word(word, next_node, value)
    end
  end

  def set_node_to_a_word(node, value)
    node.set_value(value)
    node.set_to_word
  end

  def create_word(value)
    node = Node.new(value, true)
  end

  def connect_node(node, next_node, character)
    node.children[character] = next_node
  end

  def count
    total_count_of_words
  end

  def total_count_of_words(node=root, count=0)
    return count if node.children.empty?
    node.children.each_value do |node|
      count = add_to_count(node, count)
    end
    count
  end

  def add_to_count(node, count)
    if node.word?
      count = total_count_of_words(node, count += 1)
    else
      count = total_count_of_words(node, count)
    end
  end

  def select(fragment, word)
    substring = fragment.dup
    unweighted_nodes = go_to_next_node(fragment) { |node| return_matching_nodes(node) }
    unweighted_nodes.each do |node|
      node.increase_weight(substring) if node.value == word
    end
  end

  def sort_words(nodes, substring)
    weighted_words = grab_weighted_words_for_substring(nodes, substring)
    sorted_words   = grab_sorted_words_for_substring(nodes, substring)
    words = weighted_words | sorted_words
  end

  def grab_weighted_words_for_substring(nodes, substring)
    weighted_nodes = nodes.select do |node|
      node.weight[substring] > 0
    end
    weighted_nodes.sort_by! { |node| node.weight[substring] }
    weighted_nodes.reverse!
    weighted_nodes.map! do |node|
      node.value
    end
  end

  def grab_sorted_words_for_substring(nodes, substring)
    sorted_words = nodes.map do |node|
      node.value
    end.sort
  end

  def suggest(fragment)
    substring = fragment.dup
    return [] if root.children.empty?
    nodes = go_to_next_node(fragment) { |node| return_matching_nodes(node) }
    sort_words(nodes, substring)
  end

  def go_to_next_node(fragment, node=root, &block)
    if fragment.empty?
      nodes = yield(node)
      return nodes
    else
      character = fragment.slice!(0...1)
      go_to_next_node(fragment, node.children[character], &block)
    end
  end

  def return_matching_nodes(node, matching_nodes=[])
    return matching_nodes if node.children.empty?
    matching_nodes << node if node.word? && !matching_nodes.include?(node.value)
    node.children.each_value do |node|
      add_to_matching_nodes(node, matching_nodes)
    end
    matching_nodes
  end

  def add_to_matching_nodes(node, matching_nodes)
    if node.word?
      matching_nodes << node
      return_matching_nodes(node, matching_nodes)
    else
      return_matching_nodes(node, matching_nodes)
    end
  end

  def populate(dictionary)
    split_dictionary = dictionary.split("\n")
    split_dictionary.each do |word|
      insert(word)
    end
  end
end
