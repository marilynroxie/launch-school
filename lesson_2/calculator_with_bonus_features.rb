require "yaml"
MESSAGES = YAML.load_file("messages.yml")

# Todo
# Account for float calculations accurately
# Allow numbers like .5 to be converted to 0.5
# Save case statement in variable or hash?
# Add translations

def prompt(message)
  puts("=> #{message}")
end

# Integer and float validation

def valid_number?(input)
  /^-?(?:\d+(?:\.\d*)?|\.\d+)$/.match?(input)
end

def operation_to_message(operation)
  choice = case operation
    when "1"
      "Adding"
    when "2"
      "Subtracting"
    when "3"
      "Multiplying"
    when "4"
      "Dividing"
    end

  choice
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
    prompt format(MESSAGES["what_number"], "first")
    number1 = gets.chomp
    if valid_number?(number1)
      number1 = number1.include?(".") ? number1.to_f : number1.to_i
      break
    else
      prompt(MESSAGES["valid_number"])
    end
  end

  number2 = ""

  loop do
    prompt format(MESSAGES["what_number"], "second")
    number2 = gets.chomp
    if valid_number?(number2)
      number2 = number2.include?(".") ? number2.to_f : number2.to_i
      break
    else
      prompt(MESSAGES["valid_number"])
    end
  end

  system "clear"

  # Ask the user for an operation to perform

  prompt format(MESSAGES["operator_prompt"], number1, number2)

  operator = ""
  loop do
    operator = gets.chomp

    if %w(1 2 3 4).include?(operator)
      break
    else
      prompt(MESSAGES["valid_choice"])
    end
  end

  prompt format(MESSAGES["calculating"], operation_to_message(operator))

  # Perform the operation on the two numbers

  result = case operator
    when "1"
      number1 + number2
    when "2"
      number1 - number2
    when "3"
      number1 * number2
    when "4"
      result = number1.to_f / number2.to_f
      result % 1 == 0 ? result.to_i : result
    end

  # Handle zero division and output the result
  if (number2.to_i.zero? && result.infinite?) || result.to_f.nan?
    prompt(MESSAGES["zero_division"])
  else
    prompt format(MESSAGES["result"], result)
    p result.class
  end

  prompt(MESSAGES["another_calc"])

  answer = gets.chomp
  break unless answer.downcase.start_with?("y")
  system "clear"
end

prompt format(MESSAGES["thank_you"], name)
