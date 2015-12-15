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

  def check_for_and_insert_word(word)
    if @root.children[word].nil?
      @root.children[word] = Node.new
    else
      # do some recursion to go to the next node and do shit
    end
  end
end
