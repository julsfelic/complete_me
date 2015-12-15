require 'pry'

class Node
  attr_accessor :word
  attr_reader :value, :children
  alias_method :word?, :word

  def initialize(value="", word=false)
    @value = value
    @children = {}
    @word = word
  end
end
