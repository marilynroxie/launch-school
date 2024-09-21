def featured(num)
  return "There is no possible number that fulfills those requirements." if num > 9_876_543_210
  num += 1
  loop do
    arr_num = num.to_s.split("").map(&:to_i)
    if num.odd? && num % 7 == 0 && arr_num == arr_num.uniq
      return num
    end
    num += 1
  end
end

p featured(12) == 21
p featured(20) == 21
p featured(21) == 35
p featured(997) == 1029
p featured(1029) == 1043
p featured(999_999) == 1_023_547
p featured(999_999_987) == 1_023_456_987

p featured(9_999_999_999) # -> There is no possible number that fulfills those requirements
