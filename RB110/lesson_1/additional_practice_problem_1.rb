flintstones = ["Fred", "Barney", "Wilma", "Betty", "Pebbles", "BamBam"]

hash = flintstones.each_with_object({}) do |key, hash|
  hash[key] = flintstones.index(key)
end
