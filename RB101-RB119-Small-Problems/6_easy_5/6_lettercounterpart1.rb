def letter_counter(str)
  str.split.each_with_object({}) do |word, count|
      if count.key?(word.size)
      count[word.size] += 1
    else
      count[word.size] = 1
    end
  end
end

p letter_counter('Four score and seven.') == { 3 => 1, 4 => 1, 5 => 1, 6 => 1 }
p letter_counter('Hey diddle diddle, the cat and the fiddle!') == { 3 => 5, 6 => 1, 7 => 2 }
p letter_counter("What's up doc?") == { 6 => 1, 2 => 1, 4 => 1 }
p letter_counter('') == {}
