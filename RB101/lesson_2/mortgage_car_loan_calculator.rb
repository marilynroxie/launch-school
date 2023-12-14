# Todo
# Handle whether APR is entered as whole number or decimal appropriately
# E.g. .2 should convert to 2%
# Display currency in final output when available
# Shorten line lengths

require 'yaml'

MESSAGES = YAML.load_file('loan_messages.yml')

def messages(message)
  MESSAGES[message]
end

def prompt(key, *args)
  message = messages(key) % args
  puts("=> #{message}")
end

def set_loan
  loan_amount = ''
  currency = ''

  loop do
    prompt('enter_amount')
    input = gets.chomp.strip

    currency = input[/^\p{Sc}/] || ''
    loan_amount = input.gsub(/\p{Sc}|\p{P}/, '')

    if loan_amount.empty? || loan_amount.to_f <= 0 || loan_amount.to_i.to_s == loan_amount.to_i
      prompt('positive')
    else
      break
    end
  end
  return loan_amount.to_f, currency
end

def valid_apr?(apr)
  /^(?:\d+(?:\.\d*)?|\.\d+)$/.match?(apr)
end

def set_apr
  apr = ''
  loop do
    prompt('enter_apr')
    apr = gets.chomp.strip
    if valid_apr?(apr) == false
      prompt('positive')
    else
      break
    end
  end
  apr.to_f
end

def set_duration
  loan_duration = ''
  loop do
    prompt('loan_duration')
    loan_duration = gets.chomp.strip
    if loan_duration.empty? || loan_duration.to_f <= 0
      prompt('positive')
    else
      break
    end
  end
  loan_duration.to_i
end

def monthly(apr)
  apr = apr.to_f / 100
  apr / 12
end

def monthly_payment(loan_amount, monthly_interest, months)
  monthly_payment = loan_amount[0] * (monthly_interest / (1 - ((1 + monthly_interest)**(-months))))
  monthly_payment = monthly_payment.nan? || monthly_payment.zero? ? loan_amount[0] / months : monthly_payment
  prompt('payment', loan_amount[1], monthly_payment.to_f.round(2))
end

def calc_again
  answer = ''
  loop do
    prompt('another_calc')
    answer = gets.chomp.strip.downcase
    if %w(yes y).include?(answer)
      return true
    elsif %w(no n).include?(answer)
      prompt('thank_you')
      exit
    else
      system 'clear'
      prompt('valid_calc')
    end
  end
end

loop do
  system 'clear'
  prompt('welcome')
  loan_amount = set_loan
  apr = set_apr
  loan_duration = set_duration

  monthly_interest = monthly(apr)
  months = loan_duration * 12
  sleep 0.1
  monthly_payment(loan_amount, monthly_interest, months)

  calc_again
end
