require 'yaml'

MESSAGES = YAML.load_file('loan_messages.yml')

def messages(message)
  MESSAGES[message]
end

def prompt(key, *args)
  message = messages(key) % args
  puts("=> #{message}")
end

prompt('welcome')
prompt('enter_amount')
loan_amount = gets.chomp.to_i
prompt('enter_apr')
apr = gets.chomp.to_f
prompt('loan_duration')
loan_duration = gets.chomp.to_i

apr = apr.to_f / 100
monthly_interest = apr / 12
months = loan_duration * 12

monthly_payment = loan_amount * (monthly_interest / (1 - (1 + monthly_interest) ** (-months)))
monthly_payment = monthly_payment.round(2)
prompt('payment', monthly_payment)
