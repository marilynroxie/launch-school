puts 'What is your age?'
age = gets.to_i
puts 'At what age would you like to retire?'
retire = gets.to_i
years = retire - age
current_year = Time.now.year
retirement_year = current_year.to_i + years

puts "It's #{current_year}. You will retire in #{retirement_year}."
puts "You only have #{years} years of work to go!"
