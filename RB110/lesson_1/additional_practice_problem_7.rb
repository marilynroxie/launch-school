statement = "The Flintstones Rock"
chara = statement.chars.reject { |char| char == " " }

frequencies = {}

chara.each do |char|
  if frequencies.key?(char)
    frequencies[char] += 1
  else
    frequencies[char] = 1
  end
end
