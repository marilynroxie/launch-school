a = [1, 4, 8, 11, 15, 19]

above8 = a.bsearch { |x| x > 8 }
puts above8 # => 11
