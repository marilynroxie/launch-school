["ant", "bear", "cat"].each_with_object({}) do |value, hash|
  hash[value[0]] = value
end

# each_with_object here uses the empty hash {} as an argument and returns the new hash object {"a"=>"ant", "b"=>"bear", "c"=>"cat"} since the key is the first character of each value in the hash.
