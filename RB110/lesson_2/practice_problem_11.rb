arr = [[2], [3, 5, 7, 12], [9], [11, 13, 15]]

arr.map do |element|
  element.reject do |x|
    x % 3 != 0
  end
end

