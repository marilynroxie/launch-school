# Todo
# Convert valid loan check to regex
# Shorten line length on monthly payment formula

require 'yaml'

MESSAGES = YAML.load_file('loan_messages.yml')

def messages(message)
  MESSAGES[message]
end

def prompt(key, *args)
  message = messages(key) % args
  puts("=> #{message}")
end

def valid_loan?(loan)
  loan.empty? || loan.to_f <= 0 || loan.to_i.to_s == loan.to_i
end

def set_loan
  loan = ''
  currency = ''

  loop do
    prompt('enter_amount')
    input = gets.chomp.strip
    # Regex to capture currency and separate it from raw loan amount
    currency = input[/\p{Sc}/] || ''
    loan = input.gsub(/\p{Sc}|\p{P}/, '')
    input[0] == '-' || valid_loan?(loan) ? prompt('positive') : break
  end
  # Sets array with loan amount and currency
  return currency, loan.to_f
end

def valid_apr?(apr)
  /^(?:\d+(?:\.\d*)?|\.\d+)$/.match?(apr)
end

def set_apr
  apr = ''
  loop do
    prompt('enter_apr')
    apr = gets.chomp.strip
    valid_apr?(apr) ? break : prompt('positive')
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
  apr = apr.to_f
  apr = apr < 1 ? apr * 100 : apr
  (apr / 100) / 12
end

def monthly_payment(loan, monthly_interest, months)
  monthly_payment = loan[1] * (monthly_interest / (1 - ((1 + monthly_interest)**(-months))))
  if monthly_payment.nan? || monthly_payment.zero?
    monthly_payment = loan[1] / months
  else
    monthly_payment
  end
  prompt('payment', loan[0], monthly_payment.to_f.round(2))
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
  loan = set_loan
  apr = set_apr
  loan_duration = set_duration

  monthly_interest = monthly(apr)
  months = loan_duration * 12
  sleep 0.1
  prompt('calculating')
  sleep 0.1
  monthly_payment(loan, monthly_interest, months)

  calc_again
end
