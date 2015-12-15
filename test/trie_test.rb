require 'minitest'
require 'trie'

class TrieTest < Minitest::Test
  def setup
    @trie = Trie.new
  end

  def test_can_create_an_instance
    assert_instance_of Trie, @trie
  end
end
