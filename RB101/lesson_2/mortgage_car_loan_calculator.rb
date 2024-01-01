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
  system 'clear'
  loop do
    prompt('enter_name')
    name = gets.chomp.strip.capitalize
    system 'clear'
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
    value = gets.chomp.strip
    system 'clear'
    # Regex to capture currency and separate it from raw loan amount
    currency = value[/\p{Sc}/] || ''
    loan = value.gsub(/[^\d.]/, '')
    value.to_f.negative? || valid_loan?(loan) ? prompt('amount_warn') : break
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

def valid_num?(num)
  /^\d+$/.match?(num)
end

def set_loan_years
  years = ''
  loop do
    prompt('loan_years')
    years = gets.chomp
    system 'clear'
    if valid_num?(years) == false
      prompt('number_warn')
    elsif years.to_i == 0
      prompt('zero_years')
      break if MESSAGES['options_pos'].include?(gets.chomp.downcase)
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
    system 'clear'
    if !months.to_i.between?(0, 11) || valid_num?(months) == false
      prompt('months_warn')
    elsif years == 0 && months.to_i == 0
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

def calc_summary(loan, apr, years, months, loan_length)
  system 'clear'
  sleep 0.1
  prompt('calculating')
  sleep 0.1
  prompt('summary', "#{loan[0]}#{format('%.2f', loan[1])}", apr, years,
         months)
  if years == 0 && months == 1
    prompt('month_display',
           loan_length)
  else
    prompt('months_display', loan_length)
  end
  sleep 0.1
end

def monthly_payment(loan, monthly_interest, loan_length)
  factor = (monthly_interest / (1 - ((1 + monthly_interest)**(-loan_length))))
  monthly_payment = loan[1] * factor
  if monthly_payment.nan? || monthly_payment.zero?
    monthly_payment = loan[1] / loan_length
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

name = get_name
prompt('welcome', name)

loop do
  loan = set_value
  apr = set_apr
  years = set_loan_years
  months = set_loan_months(years)
  loan_length = loan_duration(years, months)
  monthly_interest = monthly(apr)
  calc_summary(loan, apr, years, months, loan_length)
  monthly_payment(loan, monthly_interest, loan_length)
  calc_again(name)
end
