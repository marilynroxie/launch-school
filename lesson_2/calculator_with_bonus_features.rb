# Todo
# Save case statement in variable or hash?
# Finish translations
# Update operation to message based on language
# Round decimal places

require 'yaml'

MESSAGES = YAML.load_file('messages.yml')

system 'clear'

# Initialize user language

loop do
  puts 'Welcome to Calculator!
  Type en for English or jp for Japanese:

Calculatorへようこそ！
  英語を選ぶ場合はen、日本語を選ぶ場合はjpを入力してください：'
  lang = gets.chomp.strip.downcase
  if %w(en jp).include?(lang)
    LANGUAGE = lang
    break
  else
    system 'clear'
    puts("Sorry! That's not a valid input.")
  end
end

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

def operation_to_message(operation)
  case operation
  when '1'
    'Adding'
  when '2'
    'Subtracting'
  when '3'
    'Multiplying'
  when '4'
    'Dividing'
  end
end

system 'clear'

prompt('enter_name')

name = ''
loop do
  name = gets.chomp.strip.capitalize

  if name.empty?
    prompt('valid_name')
  else
    break
  end
end

prompt('hi', name)

# Ask the user for two numbers

loop do # main loop
  number1 = ''

  loop do
    prompt('first_number')
    number1 = gets.chomp
    if valid_number?(number1)
      number1 = number1.include?('.') ? number1.to_f : number1.to_i
      break
    else
      prompt('valid_number')
    end
  end

  number2 = ''

  loop do
    prompt('second_number')
    number2 = gets.chomp
    if valid_number?(number2)
      number2 = number2.include?('.') ? number2.to_f : number2.to_i
      break
    else
      prompt('valid_number')
    end
  end

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

  prompt('calculating', operation_to_message(operator))

  # Perform the operation on the two numbers

  result = case operator
           when '1'
             number1 + number2
           when '2'
             number1 - number2
           when '3'
             number1 * number2
           when '4'
             result = number1.to_f / number2.to_f
             result % 1 == 0 ? result.to_i : result.to_f
           end

  # Handle zero division and output the result

  if (number2.to_i.zero? && result.infinite?) || result.to_f.nan?
    prompt('zero_division')
  else
    prompt('result', result)
  end

  loop do
    prompt('another_calc')
    answer = gets.chomp.strip.downcase
    p answer
    if %w(yes y).include?(answer)
      break
    elsif %w(no n).include?(answer)
      prompt('thank_you', name)
      exit
    else
      system 'clear'
      puts("Sorry! That's not a valid input.")
    end
  end
end
