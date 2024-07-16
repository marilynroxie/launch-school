def multisum(number)
  (1..number).select { |i| i % 3 == 0 || i % 5 == 0 }.reduce(:+)
end

p multisum(3) == 3
p multisum(5) == 8
p multisum(10) == 33
p multisum(1000) == 234168
