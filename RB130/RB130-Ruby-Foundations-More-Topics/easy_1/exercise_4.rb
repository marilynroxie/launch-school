def divisors(num)
  arr = []
  1.upto(num) do |x|
    if num % x == 0
      arr << x
    end
  end
  p arr
end

p divisors(1) == [1]
p divisors(7) == [1, 7]
p divisors(12) == [1, 2, 3, 4, 6, 12]
p divisors(98) == [1, 2, 7, 14, 49, 98]
p divisors(99400891) == [1, 9967, 9973, 99400891]
