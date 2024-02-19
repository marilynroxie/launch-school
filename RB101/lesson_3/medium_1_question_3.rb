def factors(number)
  divisor = number
  factors = []
  while divisor > 0
    factors << number / divisor if number % divisor == 0
    divisor -= 1
  end
  factors
end

# Bonus 1: What is the purpose of the number % divisor == 0 ?

# Shows that there is no remainder in integer division

# Bonus 2: What is the purpose of the second-to-last line (line 8) in the method (the factors before the method's end)?

# Returns the factors; without it the return would be nil
