# CompleteMe

* A Trie is a type of branching data structure often used for sorting and
  querying words within a body of text.
* Root node is empty and all of its children represent the first characters of
  the various strings contained in the trie.
* Valid words must be marked
* Values tend only to be associated with leaves, and with some inner nodes that
  correspond to keys of interest.

## Development Process

1. How will you know when the problem is solved?
* We will know when the problem is solved when the spec harness passes, we are
  able to fufill the base expectations and the program is able to add words to
  the trie dictionary and look for & predict words when given a specific word

2. How will it be used? It's interface? What do you put in and what do you get
out?
* Initially, we can insert words into our trie dictionary then we can ask for
  suggestions based on the word that we put in

3. What is the most trivial use case? (mvp-mvp)
* The most trivial use case is that we create a sorter that takes in an empty
array and returns an empty array. After that, we could pass in an array with one
element and get back an array with one element.

4. What's the minimum work case?
* The minimum work case is that we pass in an array with two elements and it
returns to use the array with the two elements sorted.

5. What's the next most complex case?
* The next most complex case would be that we give our sorter an array of three
elements and it returns a sorted array of those three elements.

5. What's the next most complex case?
* The next most complex case would be passing an array of n length to our sorter
and it returns the array in proper order.

5. What's the next most complex case?
* The last thing I would like to implement if I have time is to only sort up to
the elements that have not "bubbled" to the end of an array.


6. Sketch an algorithm in pseudocode.
  1.
  2.
  3.
  4.
  5.
  6.
  7.

7. Implement

8. Whole Problem solved?
  * No? Return to 5

9. Anticipate problems / edge cases

10. Refactor

### Remember that 8 to 5 can repeat n times
