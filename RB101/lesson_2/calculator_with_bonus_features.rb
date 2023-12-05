# Todo
# Finish translations

require 'yaml'

MESSAGES = YAML.load_file('messages.yml')

system 'clear'

# Initialize user language

loop do
  puts MESSAGES['welcome']
  lang = gets.chomp.strip.downcase
  if %w(en english).include?(lang)
    LANGUAGE = "en"
    break
  elsif %w(jp japanese 日本語).include?(lang)
    LANGUAGE = "jp"
    break
  else
    system 'clear'
    puts MESSAGES['invalid_input']
  end
end

# Defining the structure of messages and prompts used throughout program

def messages(message, lang = 'en')
  MESSAGES[lang][message]
end

def prompt(key, *args)
  message = messages(key, LANGUAGE) % args
  puts("=> #{message}")
end

# Integer and float validation

def valid_number?(input)
  /^-?(?:\d+(?:\.\d*)?|\.\d+)$/.match?(input)
end

def math_sign(operator)
  MESSAGES[LANGUAGE]['math_signs'][operator.to_i]
  # MESSAGES[LANGUAGE]['math_signs'][operator.to_i]
end

# Accessing operations in yaml

def operation_to_message(operator)
  MESSAGES[LANGUAGE]['operations'][operator.to_i]
end

# Method for getting name

def get_name
  loop do
    prompt('enter_name')
    name = gets.chomp.strip.capitalize
    break name unless name.empty?
    prompt('valid_name')
  end
end

# Method for getting number

def get_number(*)
  number = gets.chomp.strip.tr('０-９', '0-9')
  loop do
    if valid_number?(number)
      number.include?('.') ? number = number.to_f : number = number.to_i
      break
    else
      prompt('valid_number')
      number = gets.chomp.strip.tr('０-９', '0-9')
    end
  end
  number
end

# Method for deciding which calculation to perform

def get_operator(operator)
  loop do
    operator = gets.chomp.tr('０-９', '0-9')

    if %w(1 2 3 4).include?(operator)
      break
    else
      prompt('valid_choice')
    end
  end
  operator
end

# Methods for performing calculations

def add(number1, number2)
  number1 + number2
end

def subtract(number1, number2)
  number1 - number2
end

def multiply(number1, number2)
  number1 * number2
end

def divide(number1, number2)
  result = number1.to_f / number2.to_f
  result % 1 == 0 ? result.to_i : result.to_f
end

# Method for setting mathematical sign

# def math_sign(operator)
#   number_signs = {
#     '1' => "+",
#     '2' => "-",
#     '3' => "×",
#     '4' => "÷"
#   }
#   number_signs[operator]
# end

# Method for performing operation

def operation(operator, number1, number2)
  case operator
  when '1' then add(number1, number2)
  when '2' then subtract(number1, number2)
  when '3' then multiply(number1, number2)
  when '4' then divide(number1, number2)
  end
end

# Method for handling zero division

def zero_division(operator, number2)
  operator == "4" && number2.zero?
end

# Method for outputing result

def equals(result)
  if result.is_a?(Float)
    prompt('result',
           result.round(2))
  else
    prompt('result', result)
  end
end

# Method for asking to perform another calculation

def calc_again(name)
  loop do
    prompt('another_calc')
    answer = gets.chomp.strip.downcase
    if %w(yes y はい うん).include?(answer)
      system 'clear'
      break
    elsif %w(no n いいえ).include?(answer)
      prompt('thank_you', name)
      exit
    else
      system 'clear'
      prompt('valid_calc')
    end
  end
end

system 'clear'

# Obtain name and greet user

name = get_name
system 'clear'
prompt('hi', name)

# Main loop begins
# Ask the user for two numbers

loop do
  prompt('first_number')
  number1 = get_number(number1)
  prompt('second_number')
  number2 = get_number(number2)
  system 'clear'

  # Ask the user for an operation to perform

  prompt('operator_prompt', number1, number2)
  operator = get_operator(operator)
  system 'clear'

  # Perform the operation on the two numbers

  prompt('calculating', operation_to_message(operator))
  sleep 0.1
  result = operation(operator, number1, number2)
  prompt('display_calc', number1, math_sign(operator), number2)
  sleep 0.1

  # Handle zero division and output the result

  zero_division_error = zero_division(operator, number2)
  zero_division_error == true ? prompt('zero_division') : equals(result)

  # Ask to perform another calculation or not

  calc_again(name)
end
