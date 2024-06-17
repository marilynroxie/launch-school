hsh = { first: ["the", "quick"], second: ["brown", "fox"], third: ["jumped"], fourth: ["over", "the", "lazy", "dog"] }

vowels = "aeoiu"

hsh.each_value do |v|
  v.each do |str|
    str.chars.each do |char|
      puts char if vowels.include?(char)
    end
  end
end
