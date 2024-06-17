arr = [[1, 6, 9], [6, 1, 7], [1, 8, 3], [1, 5, 9]]

arr.sort_by do |subarray|
  subarray.select do |x|
    x.odd?
  end
end
