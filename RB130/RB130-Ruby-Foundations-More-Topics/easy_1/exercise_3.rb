def missing(arr)
  new_arr = []

  arr.each_with_index do |element, idx|
    next if idx == arr.length - 1
    count = 1
    until element + count == arr[idx + 1]
      new_arr << element + count
      count += 1
    end
  end
  new_arr
end

p missing([-3, -2, 1, 5]) == [-1, 0, 2, 3, 4]
p missing([1, 2, 3, 4]) == []
p missing([1, 5]) == [2, 3, 4]
p missing([6]) == []
