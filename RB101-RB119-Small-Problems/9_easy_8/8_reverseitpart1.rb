def reverse_words(str)
  str.split.each do |word|
    word.reverse! if word.size >= 5
  end.join(" ")
end

p reverse_words('Professional') == 'lanoisseforP'
p reverse_words('Walk around the block') == 'Walk dnuora the kcolb'
p reverse_words('Launch School') == 'hcnuaL loohcS'
