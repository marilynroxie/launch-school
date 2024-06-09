def stringy(num)
  arr = []
  (1..num).each do |i|
    arr << '1' if i.odd?
    arr << '0' if i.even?
  end
  arr.join
end

puts stringy(6) == '101010'
puts stringy(9) == '101010101'
puts stringy(4) == '1010'
puts stringy(7) == '1010101'
