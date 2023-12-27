require 'yaml'

MONTHS_IN_YEAR = 12
MESSAGES = YAML.load_file('loan_messages.yml')

def messages(message)
  MESSAGES[message]
end

def prompt(key, *args)
  message = messages(key) % args
  puts("=> #{message}")
end

def get_name
  loop do
    prompt('enter_name')
    name = gets.chomp.strip.capitalize
    break name unless name.empty?
    prompt('valid_name')
  end
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
    loan = input.gsub(/[^\d.]/, '')
    input[0] == '-' || valid_loan?(loan) ? prompt('positive') : break
  end
  # Sets array with loan amount and currency
  return currency, loan.to_f
end

def valid_apr?(apr)
  /^(?:\d+(?:\.\d*)?|\.\d+)%?$/.match?(apr)
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
  (apr / 100) / MONTHS_IN_YEAR
end

def monthly_payment(loan, monthly_interest, months)
  factor = (monthly_interest / (1 - ((1 + monthly_interest)**(-months))))
  monthly_payment = loan[1] * factor
  if monthly_payment.nan? || monthly_payment.zero?
    monthly_payment = loan[1] / months
  else
    monthly_payment
  end
  prompt('payment',
         "#{loan[0]}#{format('%.2f', monthly_payment.to_f.round(2))}")
end

def calc_again(name)
  answer = ''
  loop do
    prompt('another_calc')
    answer = gets.chomp.strip.downcase
    if MESSAGES['options_pos'].include?(answer)
      system 'clear'
      return true
    elsif MESSAGES['options_neg'].include?(answer)
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
prompt('welcome', name)

loop do
  loan = set_loan
  apr = set_apr
  loan_duration = set_duration

  monthly_interest = monthly(apr)
  months = loan_duration * MONTHS_IN_YEAR
  system 'clear'
  sleep 0.1
  prompt('calculating')
  sleep 0.1
  prompt('summary', "#{loan[0]}#{format('%.2f', loan[1])}", apr, loan_duration)
  sleep 0.1
  monthly_payment(loan, monthly_interest, months)

  calc_again(name)
end
