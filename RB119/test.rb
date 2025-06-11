def is_prime(num)
  return false if num < 2

  (2..Math.sqrt(num)).each do |i|
    return false if num % i == 0
  end
  true
end

p is_prime(7)
p is_prime(6)
