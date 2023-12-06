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
  prompt('enter_amount')
  loan_amount = gets.chomp
  if loan_amount.empty? || loan_amount.to_f < 0
    prompt('positive')
  end
  loan_amount.to_f
end

def set_apr
  prompt('enter_apr')
  gets.chomp.to_f
end

def set_duration
  prompt('loan_duration')
  gets.chomp.to_i
end

def monthly(apr)
  apr = apr.to_f / 100
  apr / 12
end

def monthly_payment(loan_amount, monthly_interest, months)
  monthly_payment = loan_amount * (monthly_interest / (1 - ((1 + monthly_interest)**(-months))))
  monthly_payment = monthly_payment.to_f.round(2)
  prompt('payment', monthly_payment)
end

loop do
  prompt('welcome')

  loan_amount = set_loan
  apr = set_apr
  loan_duration = set_duration

  monthly_interest = monthly(apr)
  months = loan_duration * 12
  monthly_payment(loan_amount, monthly_interest, months)
end
