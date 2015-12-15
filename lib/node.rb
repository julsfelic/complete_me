require 'pry'

class Node
  attr_reader :value, :children

  def initialize
    @value = ""
    @children = {}
  end
end
