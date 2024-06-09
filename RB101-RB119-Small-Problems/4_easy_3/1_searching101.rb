arr = []

puts "==> Enter the 1st number: "
arr << gets.chomp.to_i
puts "==> Enter the 2nd number: "
arr << gets.chomp.to_i
puts "==> Enter the 3rd number: "
arr << gets.chomp.to_i
puts "==> Enter the 4th number: "
arr << gets.chomp.to_i
puts "==> Enter the 5th number: "
arr << gets.chomp.to_i
puts "==> Enter the last number: "
last = gets.chomp.to_i
puts arr.include?(last) ? "The number #{last} appears in #{arr}." : "The number #{last} does not appear in #{arr}."
