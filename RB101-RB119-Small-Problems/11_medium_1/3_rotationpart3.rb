def rotate_rightmost_digits(num, n)
  arr = num.to_s.split("")
  if n == 1
    num
  else
    arr.push(arr.slice!(-n))
    arr.join.to_i
  end
endå

def max_rotation(num)
  (num.to_s.length).times do |n|
    num = rotate_rightmost_digits(num, num.to_s.length - n)
  end
  num
end

p max_rotation(735291) == 321579
p max_rotation(3) == 3
p max_rotation(35) == 53
p max_rotation(105) == 15
p max_rotation(8_703_529_146) == 7_321_609_845
