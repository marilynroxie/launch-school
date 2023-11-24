require "yaml"
MESSAGES = YAML.load_file("messages.yml")

def prompt(message)
  puts("=> #{message}")
end

# Better integer validation

def integer?(input)
  /^-?\d+$/.match(input)
end

def number?(input)
  integer?(input) || float?(input)
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

prompt(MESSAGES["welcome"])

name = ""
loop do
  name = gets.chomp

  if name.empty?
    prompt(MESSAGES["valid_name"])
  else
    break
  end
end

prompt("Hi #{name}")

# Ask the user for two numbers

loop do # main loop
  number1 = ""

  loop do
    prompt("What's the first number?")
    number1 = gets.chomp

    if integer?(number1)
      break
    else
      prompt(MESSAGES["valid_number"])
    end
  end

  number2 = ""

  loop do
    prompt("What's the second number?")
    number2 = gets.chomp

    if integer?(number2)
      break
    else
      prompt(MESSAGES["valid_number"])
    end
  end

  # Ask the user for an operation to perform

  #   operator_prompt = <<-MSG
  #     What operation would you like to perform?
  #     1) add
  #     2) subtract
  #     3) multiply
  #     4) divide
  # MSG
  prompt(MESSAGES["operator_prompt"])

  operator = ""
  loop do
    operator = gets.chomp

    if %w(1 2 3 4).include?(operator)
      break
    else
      prompt(MESSAGES["valid_choice"])
    end
  end

  # prompt("#{operation_to_message(operator)} the two numbers...")

  # Perform the operation on the two numbers

  result = case operator
    when "1"
      number1.to_i + number2.to_i
    when "2"
      number1.to_i - number2.to_i
    when "3"
      number1.to_i * number2.to_i
    when "4"
      number1.to_f / number2.to_f
    end

  # Output the result

  if (number2.to_i.zero? && result.infinite?) || result.to_f.nan?
    prompt("Can't divide by zero")
  else
    prompt("The result is #{result}")
  end

  prompt("Do you want to perform another calculation? (Y to calculate again)")

  answer = gets.chomp
  break unless answer.downcase.start_with?("y")
end

prompt("Thank you for using the calculator. Good bye!")
