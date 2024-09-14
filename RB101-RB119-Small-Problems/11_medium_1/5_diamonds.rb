def diamonds(n)
  for i in 0...n
    stars = if i <= n / 2
        2 * i + 1
      else
        2 * (n - i - 1) + 1
      end
    puts " " * ((n - stars) / 2) + "*" * stars
  end
  nil
end

puts diamonds(3)
puts diamonds(9)
