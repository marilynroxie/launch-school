def group_anagrams(arr)
  result = {}

  arr.each do |str|
    key = str.chars.sort
    if result.has_key?(key)
      result[key].push(str)
    else
      result[key] = [str]
    end
  end

  result.each_value do |v|
    p v
  end
end

words = ["demo", "none", "tied", "evil", "dome", "mode", "live",
         "fowl", "veil", "wolf", "diet", "vile", "edit", "tide",
         "flow", "neon"]

p group_anagrams(words)
