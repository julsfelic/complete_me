require 'pry'

class Node
  attr_reader :value, :children, :word
  alias_method :word?, :word

  def initialize
    @value = ""
    @children = {}
    @word = false
  end
end
