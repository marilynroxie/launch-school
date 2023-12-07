def valid_int(integer)
  loop do
    puts ">> Please enter an integer greater than 0: "
    integer = gets.chomp.to_i
    if integer.to_i.to_s == "0"
      puts ">> Enter a valid integer"
    else
      break
    end
  end
  integer
end

def find_sum(integer)
  total = 0
  1.upto(integer) { |count| total += count }
  total
end

def find_product(integer)
  total = 1
  1.upto(integer) { |count| total *= count }
  total
end

integer = valid_int(integer)

loop do
  puts ">> Enter 's' to compute the sum, 'p' to compute the product."
  choice = gets.chomp.downcase

  if choice == "s"
    sum = find_sum(integer)
    puts "The sum of the integers between 1 and #{integer} is #{sum}."
    break
  elsif choice == "p"
    product = find_product(integer)
    puts "The product of the integers between 1 and #{integer} is #{product}."
    break
  else
    puts "I don't recognize that command."
  end
end
