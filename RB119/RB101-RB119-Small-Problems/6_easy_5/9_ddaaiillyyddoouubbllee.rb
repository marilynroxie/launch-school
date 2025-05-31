def crunch(str)
  arr = []
  str.split("").to_a.each do |chara|
    arr << chara unless arr.last == chara
  end
  arr.join
end

p crunch("ddaaiillyy ddoouubbllee") == "daily double"
p crunch("4444abcabccba") == "4abcabcba"
p crunch("ggggggggggggggg") == "g"
p crunch("a") == "a"
p crunch("") == ""
