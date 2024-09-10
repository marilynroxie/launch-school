def rotate_rightmost_digits(num, n)
  arr = num.to_s.split("")
  if n == 1
    num
  else
    arr.push(arr.slice!(-n))
    arr.join.to_i
  end
end

p rotate_rightmost_digits(735291, 1) == 735291
p rotate_rightmost_digits(735291, 2) == 735219
p rotate_rightmost_digits(735291, 3) == 735912
p rotate_rightmost_digits(735291, 4) == 732915
p rotate_rightmost_digits(735291, 5) == 752913
p rotate_rightmost_digits(735291, 6) == 352917
