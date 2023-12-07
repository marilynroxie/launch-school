require 'yaml'

MESSAGES = YAML.load_file('messages.yml')

system 'clear'

loop do
  puts MESSAGES['welcome']
  lang = gets.chomp.strip.downcase
  if MESSAGES['en_opt'].include?(lang)
    LANGUAGE = "en"
    break
  elsif MESSAGES['jp_opt'].include?(lang)
    LANGUAGE = "jp"
    break
  else
    system 'clear'
    puts MESSAGES['invalid_input']
  end
end

def messages(message, lang = 'en')
  MESSAGES[lang][message]
end

def prompt(key, *args)
  message = messages(key, LANGUAGE) % args
  puts("=> #{message}")
end

def valid_number?(input)
  /^-?(?:\d+(?:\.\d*)?|\.\d+)$/.match?(input)
end

def math_sign(operator)
  MESSAGES[LANGUAGE]['math_signs'][operator.to_i]
end

def operation_to_message(operator)
  MESSAGES[LANGUAGE]['operations'][operator.to_i]
end

def get_name
  loop do
    prompt('enter_name')
    name = gets.chomp.strip.capitalize
    break name unless name.empty?
    prompt('valid_name')
  end
end

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

def operation(operator, number1, number2)
  case operator
  when '1' then number1 + number2
  when '2' then number1 - number2
  when '3' then number1 * number2
  when '4' then number1.to_f / number2.to_f
  end
end

def zero_division(operator, number2)
  operator == "4" && number2.zero?
end

def equals(result)
  result % 1 < 0.000001 && 1 - (result % 1) < 0.000001 ? result.to_i : result.to_f
  if result.is_a?(Float)
    prompt('result', result.round(2))
  else
    prompt('result', result)
  end
end

def calc_again(name)
  loop do
    prompt('another_calc')
    answer = gets.chomp.strip.downcase
    if MESSAGES[LANGUAGE]['calc_options_pos'].include?(answer)
      system 'clear'
      break
    elsif MESSAGES[LANGUAGE]['calc_options_neg'].include?(answer)
      prompt('thank_you', name)
      exit
    else
      system 'clear'
      prompt('valid_calc')
    end
  end
end

system 'clear'

name = get_name
system 'clear'
prompt('hi', name)

loop do
  prompt('first_number')
  number1 = get_number(number1)
  prompt('second_number')
  number2 = get_number(number2)
  system 'clear'

  prompt('operator_prompt', number1, number2)
  operator = get_operator(operator)
  system 'clear'

  prompt('calculating', operation_to_message(operator))
  sleep 0.1
  result = operation(operator, number1, number2)
  prompt('display_calc', number1, math_sign(operator), number2)
  sleep 0.1

  zero_division_error = zero_division(operator, number2)
  zero_division_error == true ? prompt('zero_division') : equals(result)

  calc_again(name)
end
