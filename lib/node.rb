require 'pry'

class Node
  attr_accessor :word, :value
  attr_reader :children
  alias_method :word?, :word

  def initialize(value="", word=false)
    @value = value
    @children = {}
    @word = word
  end
end
