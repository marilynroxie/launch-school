puts '>> Please enter an integer greater than 0:'
integer = gets.chomp.to_i
puts ">> Enter 's' to compute the sum, 'p' to compute the product."
choice = gets.chomp.downcase
if choice == 's'
  puts "The sum of the integers between #{start} and #{integer} is #{result}."
elsif choice = 'p'
  puts "The product of the integers between #{start} and #{integer} is #{result}."
else
  puts "I don't recognize that command"
end
