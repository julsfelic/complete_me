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
      # save only the value if it is a word
      value += character
      next_node = Node.new
      if word.length == 0
        next_node.value = value
        next_node.word = true
        node.children[character] = next_node
        break
      end
      if node.children[character].nil?
        node.children[character] = next_node
        check_for_and_insert_word(word, next_node, value)
      else
        next_node = node.children[character]
        check_for_and_insert_word(word, next_node, value)
      end
    end
  end

  # def new_node_with_value(word)
  #   Node.new(word)
  # end
end

complete = CompleteMe.new
complete.insert("catty")
complete.insert("cat")
