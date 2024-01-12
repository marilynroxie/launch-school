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
  /^(?!0\d*$)\d{1,3}(,?\d{3})*(\.\d{1,2})?$/.match?(loan) && loan.to_f > 0.0
end

def valid_duration?(duration)
  /^\d+$/.match?(duration)
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
    loan = value.gsub(/[\p{Sc},]/, '')
    valid_loan?(loan) ? break : prompt('amount_warn')
  end
  # Sets array with loan amount and currency
  return currency, loan.to_f
end

def valid_apr?(apr)
  /^(?:\d+(?:\.\d{1,2})?|\.\d{1,2})%?$/.match?(apr)
end

def set_apr
  apr = ''
  loop do
    prompt('enter_apr')
    apr = gets.chomp.strip
    system 'clear'
    if valid_apr?(apr) == false
      prompt('invalid_number_warn')
    elsif apr.to_f < 1
      apr_confirm(apr)
      break if messages('options_pos').include?(gets.chomp.downcase)
    else
      break
    end
  end
  apr
end

def display_apr(apr)
  if apr.to_f < 1 && !apr.include?("%")
    apr = apr.to_f * 100
  else
    apr = apr.to_f
  end
  apr
end

def apr_confirm(apr)
  if (apr.to_f.abs > 0.0001 && apr.to_f < 1) && !apr.include?("%")
    prompt('apr_conversion', apr, display_apr(apr))
  else
    prompt('small_apr', apr.to_f)
  end
end

def set_loan_years
  years = ''
  loop do
    prompt('loan_years')
    years = gets.chomp
    system 'clear'
    if valid_duration?(years) == false
      prompt('invalid_number_warn')
    elsif years.to_i == 0 || years.to_i > 30
      prompt('years_warn', years)
      break if messages('options_pos').include?(gets.chomp.downcase)
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
    if !months.to_i.between?(0, 11) || valid_duration?(months) == false
      prompt('months_warn')
    elsif years == 0 && months.to_i == 0
      prompt('zero_months_warn')
    else
      break
    end
  end
  months.to_i
end

def monthly_rate(apr)
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
  unless years == 0 && months > 1
    prompt('months_display', loan_length)
  end
  sleep 0.1
end

def monthly_payment(loan, monthly_interest, loan_length)
  if monthly_interest.zero?
    monthly_payment = loan[1] / loan_length
  else
    factor = (monthly_interest / (1 - ((1 + monthly_interest)**(-loan_length))))
    monthly_payment = loan[1] * factor
  end
  prompt('payment',
         "#{loan[0]}#{format('%.2f', monthly_payment.to_f.round(2))}")
end

def calc_again(name)
  answer = ''
  loop do
    prompt('another_calc')
    answer = gets.chomp.strip.downcase
    if messages('options_pos').include?(answer)
      system 'clear'
      return true
    elsif messages('options_neg').include?(answer)
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
  apr = display_apr(set_apr)
  years = set_loan_years
  months = set_loan_months(years)
  loan_length = loan_duration(years, months)
  monthly_interest = monthly_rate(apr)
  calc_summary(loan, apr, years, months, loan_length)
  monthly_payment(loan, monthly_interest, loan_length)
  calc_again(name)
end
