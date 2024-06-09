def century(year)
  century = year / 100 + 1
  century -= 1 if year % 100 == 0
  if [11, 12, 13].include?(century % 100)
    century.to_s + "th"
  elsif century % 10 == 1
    century.to_s + "st"
  elsif century % 10 == 2
    century.to_s + "nd"
  elsif century % 10 == 3
    century.to_s + "rd"
  else
    century.to_s + "th"
  end
end

p century(2000) == "20th"
p century(2001) == "21st"
p century(1965) == "20th"
p century(256) == "3rd"
p century(5) == "1st"
p century(10103) == "102nd"
p century(1052) == "11th"
p century(1127) == "12th"
p century(11201) == "113th"
