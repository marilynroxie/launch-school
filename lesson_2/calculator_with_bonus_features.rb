require "yaml"
MESSAGES = YAML.load_file("messages.yml")

def prompt(message)
  puts("=> #{message}")
end

# Better integer validation; need to add functionality for performing operations with decimals

def integer?(input)
  /^-?\d+$/.match(input)
end

def float?(input)
  /\d/.match(input) && /^-?\d*\.?\d*$/.match(input)
end

def operation_to_message(op)
  case op
  when "1"
    "Adding"
  when "2"
    "Subtracting"
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

prompt format(MESSAGES["hi"], name)

# Ask the user for two numbers

loop do # main loop
  number1 = ""

  loop do
    prompt("What's the first number?")
    number1 = gets.chomp

    if integer?(number1) || float?(number1)
      break
    else
      prompt(MESSAGES["valid_number"])
    end
  end

  number2 = ""

  loop do
    prompt("What's the second number?")
    number2 = gets.chomp

    if integer?(number2) || float?(number2)
      break
    else
      prompt(MESSAGES["valid_number"])
    end
  end

  # Ask the user for an operation to perform

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

  prompt("#{operation_to_message(operator)} the two numbers...")

  # Perform the operation on the two numbers

  result = case operator
    when "1"
      number1.to_i + number2.to_i
    when "2"
      number1.to_i - number2.to_i
    when "3"
      number1.to_i * number2.to_i
    when "4"
      result = number1.to_f / number2.to_f
      result % 1 == 0 ? result.to_i : result
    end

  # Handle zero division and onutput the result

  if (number2.to_i.zero? && result.infinite?) || result.to_f.nan?
    prompt(MESSAGES["zero_division"])
  else
    prompt format(MESSAGES["result"], result)
    p result.class
  end

  prompt(MESSAGES["another_calc"])

  answer = gets.chomp
  break unless answer.downcase.start_with?("y")
end

prompt(MESSAGES["thank_you"])
