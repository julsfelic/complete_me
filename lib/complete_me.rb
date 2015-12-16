require_relative 'node'
require 'pry'

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
      value += character
      next_node = Node.new
      if word.length == 0
        if node.children[character].nil?
          next_node = create_word(value)
          connect_node(node, next_node, character)
        else
          node.children[character].value = value
          node.children[character].word  = true
        end
      elsif node.children[character].nil?
        connect_node(node, next_node, character)
        check_for_and_insert_word(word, next_node, value)
      else
        next_node = node.children[character]
        check_for_and_insert_word(word, next_node, value)
      end
    end
  end

  def create_word(value)
    node = Node.new(value, true)
  end

  def connect_node(node, next_node, character)
    node.children[character] = next_node
  end

  def count
    total_count_of_words
  end

  def total_count_of_words(node=root, count=0)
    return count if node.children.empty?
    node.children.each do |key, node|
      if node.word
        count = total_count_of_words(node, count += 1)
      else
        count = total_count_of_words(node, count)
      end
    end
    count
  end

  def suggest(fragment)
    return [] if root.children.empty?
    go_to_next_node(fragment)
  end

  def go_to_next_node(fragment, node=root)
    if fragment.length == 0
      value = find_all_matching_words(node)
      return value
    end
    character = fragment.slice!(0...1)
    unless node.children[character].nil?
      go_to_next_node(fragment, node.children[character])
    end
  end

  def find_all_matching_words(node, matching_words=[])
    return matching_words if node.children.empty?
    matching_words << node.value if node.word? && !matching_words.include?(node.value)
    node.children.each do |key, node|
      if node.word
        matching_words << node.value
        matching_words = find_all_matching_words(node, matching_words)
      end
      # if node.word == false
        matching_words = find_all_matching_words(node, matching_words)
      # end
    end
    matching_words
  end

  def populate(dictionary)
    split_dictionary = dictionary.split("\n")
    split_dictionary.each do |word|
      insert(word)
    end
  end
end

# complete = CompleteMe.new
# complete.insert("doggerel")
# complete.insert("doggereler")
# complete.insert("doggerelism")
# complete.insert("doggerelist")
# complete.insert("doggerelize")
# complete.insert("doggerelizer")
# dictionary = File.read("/usr/share/dict/words")
# complete.populate(dictionary)
#
# complete.count
# binding.pry
# complete.suggest("doggerel")
