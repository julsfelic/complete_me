class Node
  attr_accessor :value, :word
  attr_reader :children, :value, :word
  alias_method :word?, :word

  def initialize(value="", word=false)
    @value = value
    @children = {}
    @word = word
  end
end
