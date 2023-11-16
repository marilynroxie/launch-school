puts "Teddy is #{rand(20..200).to_s} years old!"

# Further Exploration

def age(name = "Teddy")
  puts "#{name} is #{rand(20..200).to_s} years old!"
end

age()
age("Marilyn")
