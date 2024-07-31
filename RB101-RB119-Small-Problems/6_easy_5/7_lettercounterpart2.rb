def letter_counter(str)
  str.split.each_with_object({}) do |word, count|
    word = word.delete('^A-Za-z')
      if count.key?(word.size)
      count[word.size] += 1
    else
      count[word.size] = 1
    end
  end
end

p letter_counter('Four score and seven.') == { 3 => 1, 4 => 1, 5 => 2 }
p letter_counter('Hey diddle diddle, the cat and the fiddle!') == { 3 => 5, 6 => 3 }
p letter_counter("What's up doc?") == { 5 => 1, 2 => 1, 3 => 1 }
p letter_counter('') == {}
