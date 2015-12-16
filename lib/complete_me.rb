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
end

complete = CompleteMe.new
complete.insert("catty")
complete.insert("cat")
