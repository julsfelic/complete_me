require 'pry'
require_relative 'node'

class CompleteMe
  attr_reader :root

  def initialize
    @root = Node.new
  end

  def insert(word)
    raise ArgumentError, 'Argument is not a word' unless word.is_a?(String)
  end
end
