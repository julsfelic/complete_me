class Node
  attr_reader :children, :value, :word, :weight
  alias_method :word?, :word

  def initialize(value="", word=false)
    @value = value
    @children = {}
    @word = word
    @weight = Hash.new(0)
  end

  def increase_weight(fragment="")
    @weight[fragment] += 1
  end

  def set_value(value)
    @value = value
  end

  def set_to_word
    @word = true
  end
end
