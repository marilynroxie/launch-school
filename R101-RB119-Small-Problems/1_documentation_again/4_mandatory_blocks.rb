a = [1, 4, 8, 11, 15, 19]

above_8 = a.bsearch { |x| x > 8 }
puts above_8 # => 11
