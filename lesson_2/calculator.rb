# Ask the user for two numbers
# Ask the user for an operation to perform
# Perform the operation on the two numbers
# Output the result

def prompt(message)
  Kernel.puts("=> #{message}")
end

prompt("Welcome to Calculator!")

prompt("What's the first number?")
number1 = Kernel.gets().chomp()

prompt("What's the second number?")
number2 = Kernel.gets().chomp()

prompt("What operation would you like to perform? 1) add, 2) subtract, 3) multiply, 4) divide ")
operator = Kernel.gets().chomp()

result = case operator
  when "1"
    number1.to_i() + number2.to_i()
  when "2"
    number1.to_i() - number2.to_i()
  when "3"
    number1.to_i() * number2.to_i()
  when "4"
    number1.to_f() / number2.to_f()
  else
  end

prompt("The result is #{result}")
