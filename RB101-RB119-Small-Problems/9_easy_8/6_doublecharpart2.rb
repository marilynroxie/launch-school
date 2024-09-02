def double_consonants(str)
  str.split("").each do |char|
    if char =~ /[a-z&&[^aeiou]]/i
      char.concat(char)
    end
  end.join("")
end

p double_consonants('String') == "SSttrrinngg"
p double_consonants("Hello-World!") == "HHellllo-WWorrlldd!"
p double_consonants("July 4th") == "JJullyy 4tthh"
p double_consonants('') == ""
