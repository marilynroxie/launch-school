def swap(str)
  str = str.split.map do |word|
    word[0], word[-1] = word[-1], word[0] if word.length > 1
    word
  end
  str.join(" ")
end

p swap("Oh what a wonderful day it is") == "hO thaw a londerfuw yad ti si"
p swap("Abcde") == "ebcdA"
p swap("a") == "a"

# Further Exploration

# How come our solution passes word into the swap_first_last_characters method invocation instead of just passing the characters that needed to be swapped? Suppose we had this implementation:

def swap_first_last_characters(a, b)
  a, b = b, a
end

# and called the method like this:

# swap_first_last_characters(word[0], word[-1])

# Would this method work? Why or why not?
word = "wonderful"
p swap_first_last_characters(word[0], word[-1]) # ["l", "w"]
p word # "wonderful"

# This doesn't work because the caller is not mutated, thus only copies are being operated on; only the elements in an array are returned.
