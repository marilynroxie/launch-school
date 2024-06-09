def prompt(message)
  puts "==> #{message}"
end

puts prompt("Enter the first number:")
first_number = gets.chomp.to_i
puts prompt("Enter the second number:")
second_number = gets.chomp.to_i

def arithmetic(first_number, second_number)
  prompt("#{first_number} + #{second_number} = #{first_number + second_number}")
  prompt("#{first_number} - #{second_number} = #{first_number - second_number}")
  prompt("#{first_number} * #{second_number} = #{first_number * second_number}")
  prompt("#{first_number} / #{second_number} = #{first_number / second_number}")
  prompt("#{first_number} % #{second_number} = #{first_number % second_number}")
  prompt("#{first_number} ** #{second_number} = #{first_number ** second_number}")
end

arithmetic(first_number, second_number)
