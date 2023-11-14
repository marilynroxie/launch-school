# Ask the user for two numbers
# Ask the user for an operation to perform
# Perform the operation on the two numbers
# Output the result

def prompt(message)
  Kernel.puts("=> #{message}")
end

def valid_number?(num)
  num.to_i() != 0
end

def operation_to_message(op)
  case op
  when "1"
    "Adding"
  when "2"
    "Substracting"
  when "3"
    "Multiplying"
  when "4"
    "Dividing"
  end
end

prompt("Welcome to Calculator! Enter your name: ")

name = ""
loop do
  name = Kernel.gets().chomp()

  if name.empty?()
    prompt("Make sure to use a valid name.")
  else
    break
  end
end

prompt("Hi #{name}")

loop do # main loop
  number1 = ""

  loop do
    prompt("What's the first number?")
    number1 = Kernel.gets().chomp()

    if valid_number?(number1)
      break
    else
      prompt("Hmm.. that doesn't look like a valid number")
    end
  end

  number2 = ""

  loop do
    prompt("What's the second number?")
    number2 = Kernel.gets().chomp()

    if valid_number?(number2)
      break
    else
      prompt("Hmm.. that doesn't look like a valid number")
    end
  end

  operator_prompt = <<-MSG
    What operation would you like to perform?
    1) add
    2) subtract
    3) multiply
    4) divide
MSG
  prompt(operator_prompt)

  operator = ""
  loop do
    operator = Kernel.gets().chomp()

    if %w(1 2 3 4).include?(operator)
      break
    else
      prompt("Must choose 1, 2, 3, or 4")
    end
  end

  prompt("#{operation_to_message(operator)} the two numbers...")

  result = case operator
    when "1"
      number1.to_i() + number2.to_i()
    when "2"
      number1.to_i() - number2.to_i()
    when "3"
      number1.to_i() * number2.to_i()
    when "4"
      number1.to_f() / number2.to_f()
    end

  prompt("The result is #{result}")

  prompt("Do you want to perform another calculation? (Y to calculate again)")

  answer = Kernel.gets().chomp()
  break unless answer.downcase().start_with?("y")
end

prompt("Thank you for using the calculator. Good bye!")

=begin

Calculator Bonus Features

1. Better integer validation

The current method of validating the input for a number is very weak. It's also not fully accurate, as you cannot enter a 0. Come up with a better way of validating input for integers.

2. Number validation.

Suppose we're building a scientific calculator, and we now need to account for inputs that include decimals. How can we build a validating method, called number?, to verify that only valid numbers -- integers or floats -- are entered?

3. Our operation_to_message method is a little dangerous, since we're relying on the case statement being the last expression in the method. Suppose we needed to add some code after the case statement within the method? What changes would be needed to keep the method working with the rest of the program?

4. Extracting messages in the program to a configuration file.

There are lots of messages sprinkled throughout the program. Could we move them into some configuration file and access by key? This would allow us to manage the messages much easier, and we could even internationalize the messages.

5. Your calculator program is a hit, and it's being used all over the world! Problem is, not everyone speaks English. You need to now internationalize the messages in your calculator. You've already done the hard work of extracting all the messages to a configuration file. Now, all you have to do is send that configuration file to translators and call the right translation in your code.

=end
