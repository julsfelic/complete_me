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
        next_node = create_word(value)
        connect_node(node, next_node, character)
      elsif node.children[character].nil?
        connect_node(node, next_node, character)
        check_for_and_insert_word(word, next_node, value)
      else
        next_node = node.children[character]
        check_for_and_insert_word(word, next_node, value)
      end
    end
  end

  def create_word(value)
    node = Node.new(value, true)
  end

  def connect_node(node, next_node, character)
    node.children[character] = next_node
  end

  def count
    find_amount_of_words
  end

  def find_amount_of_words(node=root, count=0)
    node.children.each do |key, node|
      return if node.word == false && node.children.empty?
      if node.word
        count += 1
        break
      end
      if node.word == false
        count = find_amount_of_words(node, count)
      end
    end
    count
  end

  def suggest(fragment)
    return [] if root.children.empty?
    go_to_next_node(fragment)
  end

  def go_to_next_node(fragment, node=root)
    if fragment.length == 0
      return find_all_matching_words(node)
    end
    character = fragment.slice!(0...1)
    unless node.children[character].nil?
      go_to_next_node(fragment, node.children[character])
    end
  end

  def find_all_matching_words(node, matching_words=[])
    node.children.each do |key, node|
      return if node.word == false && node.children.empty?
      if node.word
        matching_words << node.value
        break
      end
      if node.word == false
        matching_words = find_all_matching_words(node, matching_words)
      end
    end
    matching_words
  end
end

complete = CompleteMe.new
complete.insert("catty")
complete.insert("cat")
