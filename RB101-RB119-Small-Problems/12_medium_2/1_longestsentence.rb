gettysburg = File.read("1_longestsentence.txt")

sentences = gettysburg.split(/\.|\?|!/)

longest_sentence = sentences.max_by do |sentence|
  sentence.length
end.strip

puts "'#{longest_sentence}' has #{longest_sentence.split.length} words"
