def swap(str)
  str = str.split.map do |word|
    word[0], word[-1] = word[-1], word[0] if word.length > 1
    word
  end
  str.join(" ")
end

p swap('Oh what a wonderful day it is') == 'hO thaw a londerfuw yad ti si'
p swap('Abcde') == 'ebcdA'
p swap('a') == 'a'
