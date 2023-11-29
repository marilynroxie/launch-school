# Todo
# Move both getting number and case operator into their own methods
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
  elsif %w(jp japanese).include?(lang)
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

# Accessing operations in yaml

def operation_to_message(operator)
  MESSAGES[LANGUAGE]['operations'][operator.to_i]
end

# Method for getting name

def get_name
  loop do
    prompt('enter_name')
    name = gets.chomp.strip.capitalize
    if name.empty?
      prompt('valid_name')
    else
      return name
    end
  end
end

# Method for getting number

def get_number
  number = gets.chomp
  if valid_number?(number)
    number.include?('.') ? number.to_f : number.to_i
  else
    prompt('valid_number')
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
  prompt('what_number', "first")
  # prompt('first_number')
  number1 = get_number
  prompt('what_number', "second")
  # prompt('second_number')
  number2 = get_number

  system 'clear'

  # Ask the user for an operation to perform

  prompt('operator_prompt', number1, number2)

  operator = ''
  loop do
    operator = gets.chomp

    if %w(1 2 3 4).include?(operator)
      break
    else
      prompt('valid_choice')
    end
  end

  system 'clear'
  prompt('calculating', operation_to_message(operator))
  sleep 0.1

  # Perform the operation on the two numbers

  result = case operator
           when '1'
             mathsym = "+"
             number1 + number2
           when '2'
             mathsym = "-"
             number1 - number2
           when '3'
             mathsym = "*"
             number1 * number2
           when '4'
             mathsym = "/"
             result = number1.to_f / number2.to_f
             result % 1 == 0 ? result.to_i : result.to_f
           end

  prompt('display_calc', number1, mathsym, number2)
  sleep 0.1

  # Handle zero division and output the result

  if (number2.to_i.zero? && result.infinite?) || result.to_f.nan?
    prompt('zero_division')
  elsif result.is_a?(Float)
    prompt('result', result.round(2))
  else
    prompt('result', result)
  end

  # Ask to perform another calculation or not

  loop do
    prompt('another_calc')
    answer = gets.chomp.strip.downcase
    p answer
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
