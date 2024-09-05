def oddities(arr)
  newarr = []
  arr.each_with_index do |el, idx|
    newarr << el if idx.even?
  end
  newarr
end

p oddities([2, 3, 4, 5, 6]) == [2, 4, 6]
p oddities([1, 2, 3, 4, 5, 6]) == [1, 3, 5]
p oddities(["abc", "def"]) == ["abc"]
p oddities([123]) == [123]
p oddities([]) == []
p oddities([1, 2, 3, 4, 1]) == [1, 3, 1]
