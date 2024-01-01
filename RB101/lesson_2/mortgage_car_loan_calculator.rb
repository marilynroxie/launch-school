require 'yaml'

# Todo
# Address Rubocop violations for condition size in years
# and line length in loan years and months

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

def set_value
  loan = ''
  currency = ''

  loop do
    prompt('enter_amount')
    input = gets.chomp.strip
    # Regex to capture currency and separate it from raw loan amount
    currency = input[/\p{Sc}/] || ''
    loan = input.gsub(/[^\d.]/, '')
    input[0] == '-' || valid_loan?(loan) ? prompt('number_warn') : break
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

def valid_num?(input)
  /^\d+$/.match?(input)
end

def set_loan_years
  years = ''
  loop do
    prompt('loan_years')
    years = gets.chomp
    if years.empty? || years.to_i < 0 || valid_num?(years) == false
      system 'clear'
      prompt('number_warn')
    elsif years.to_i.zero?
      system 'clear'
      prompt('zero_years')
      answer = gets.chomp.downcase
      break if MESSAGES['options_pos'].include?(answer)
    else
      break
    end
  end
  years.to_i
end

def set_loan_months(years)
  months = ''
  loop do
    prompt('loan_months', years)
    months = gets.chomp
    if months.empty? || !months.to_i.between?(0,
                                              11) || valid_num?(months) == false
      system 'clear'
      prompt('months_warn')
    elsif years == 0 && months.to_i == 0
      system 'clear'
      prompt('zero_months_warn')
    else
      break
    end
  end
  months.to_i
end

def monthly(apr)
  apr = apr.to_f
  apr = apr < 1 ? apr * 100 : apr
  (apr / 100) / MONTHS_IN_YEAR
end

def loan_duration(years, months)
  if years > 1 && months == 0
    duration = years * MONTHS_IN_YEAR
  else
    duration = (years * MONTHS_IN_YEAR) + months
  end
  duration
end

def monthly_payment(loan, monthly_interest, loan_duration)
  factor = (monthly_interest / (1 - ((1 + monthly_interest)**(-loan_duration))))
  monthly_payment = loan[1] * factor
  if monthly_payment.nan? || monthly_payment.zero?
    monthly_payment = loan[1] / loan_duration
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
  loan = set_value
  apr = set_apr
  years = set_loan_years
  months = set_loan_months(years)
  loan_duration = loan_duration(years, months)
  monthly_interest = monthly(apr)
  system 'clear'
  sleep 0.1
  prompt('calculating')
  sleep 0.1
  prompt('summary', "#{loan[0]}#{format('%.2f', loan[1])}", apr, years,
         months)
  if years == 0 && months == 1
    prompt('month_display',
           loan_duration)
  else
    prompt('months_display', loan_duration)
  end
  sleep 0.1
  monthly_payment(loan, monthly_interest, loan_duration)

  calc_again(name)
end
