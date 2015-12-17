require_relative 'node'
require 'pry'

class CompleteMe
  attr_reader :root

  def initialize
    @root = Node.new
  end

  def insert(word)
    raise ArgumentError, 'Argument is not a word' unless word.is_a?(String)
    check_for_and_insert_word(word)
  end

  def check_for_and_insert_word(word, node=root, value="")
    until word.length == 0
      character = word.slice!(0...1)
      value += character
      next_node = Node.new
      if word.length == 0
        if node.children[character].nil?
          next_node = create_word(value)
          connect_node(node, next_node, character)
        else
          set_node_to_a_word(node.children[character])
        end
      elsif node.children[character].nil?
        connect_node(node, next_node, character)
        check_for_and_insert_word(word, next_node, value)
      else
        next_node = node.children[character]
        check_for_and_insert_word(word, next_node, value)
      end
    end
  end

  def set_node_to_a_word(node)
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
      if node.word?
        count = total_count_of_words(node, count += 1)
      else
        count = total_count_of_words(node, count)
      end
    end
    count
  end

  def select(fragment, word)
    substring = fragment.dup
    unweighted_nodes = go_to_next_node(fragment) { |node| return_matching_nodes(node) }
    unweighted_nodes.each do |node|
      node.increase_weight(substring) if node.value == word
    end
  end

  def sort_words(nodes, substring)
    weighted_nodes = nodes.select do |node|
      node.weight[substring] > 0
    end
    weighted_nodes.sort_by { |node| node.weight[substring] }
    weighted_words = weighted_nodes.map do |node|
      node.value
    end
    sorted_words = nodes.map do |node|
      node.value
    end.sort
    words = weighted_words | sorted_words
  end

  def suggest(fragment)
    substring = fragment.dup
    return [] if root.children.empty?
    nodes = go_to_next_node(fragment) { |node| return_matching_nodes(node) }
    sort_words(nodes, substring)
  end

  def go_to_next_node(fragment, node=root, &block)
    if fragment.length == 0
      words = yield(node)
      return words
    end
    character = fragment.slice!(0...1)
    unless node.children[character].nil?
      go_to_next_node(fragment, node.children[character], &block)
    end
  end

  def return_matching_nodes(node, matching_nodes=[])
    return matching_nodes if node.children.empty?
    matching_nodes << node if node.word? && !matching_nodes.include?(node.value)
    node.children.each_value do |node|
      if node.word?
        matching_nodes << node
        matching_nodes = return_matching_nodes(node, matching_nodes)
      end
      matching_nodes = return_matching_nodes(node, matching_nodes)
    end
    matching_nodes
  end

  def find_all_matching_words(node, matching_words=[])
    return matching_words if node.children.empty?
    matching_words << node.value if node.word? && !matching_words.include?(node.value)
    node.children.each do |key, node|
      if node.word?
        matching_words << node.value
        matching_words = find_all_matching_words(node, matching_words)
      end
      matching_words = find_all_matching_words(node, matching_words)
    end
    matching_words
  end

  def populate(dictionary)
    split_dictionary = dictionary.split("\n")
    split_dictionary.each do |word|
      insert(word)
    end
  end
end
