def reverse_sentence(sentence)
  words = sentence.split(" ")
  reversed_words = []

  i = 0
  until words.empty?
    reversed_words << words.last
    i += 1
    words.delete_at(-1)
  end

  reversed_words.join(" ")
end

p reverse_sentence("how are you doing")
# expected output: 'doing you are how'
