require 'pry'

class Node
  attr_reader :value, :children, :word
  alias_method :word?, :word

  def initialize(value="", word=false)
    @value = value
    @children = {}
    @word = word
  end
end
