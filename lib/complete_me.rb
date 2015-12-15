require 'pry'
require_relative 'node'

class CompleteMe
  attr_reader :root

  def initialize
    @root = Node.new
  end

  def insert(word)
    raise ArgumentError, 'Argument is not a word' unless word.is_a?(String)
    check_for_and_insert_word(word)
  end

  def check_for_and_insert_word(word, node=root)
    until word.length == 0
      character = word.slice!(0...1)
      value = node.value + character
      next_node = new_node_with_value(value)
      if node.children[character].nil?
        node.children[character] = next_node
        check_for_and_insert_word(word, next_node)
      else
        next_node = node.children[character]
        check_for_and_insert_word(word, next_node)
      end
      next_node.word = true if word.length == 0
    end
  end

  def new_node_with_value(word)
    Node.new(word)
  end
end
