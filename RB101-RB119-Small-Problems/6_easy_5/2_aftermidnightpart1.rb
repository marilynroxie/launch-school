def time_of_day(number)
  number = number % 1440
  hours, minutes = number.divmod(60)
  format("%02d:%02d", hours, minutes)
end

p time_of_day(0) == "00:00"
p time_of_day(-3) == "23:57"
p time_of_day(35) == "00:35"
p time_of_day(-1437) == "00:03"
p time_of_day(3000) == "02:00"
p time_of_day(800) == "13:20"
p time_of_day(-4231) == "01:29"

# Further Exploration 1
# Already satisfied in original solution

# Further Exploration 2
# How would you approach this problem if you were allowed to use ruby's Date and Time classes?

def time_of_day(number)
  (Time.new(2024) + (number * 60)).strftime("%H:%M")
end

p time_of_day(0) == "00:00"
p time_of_day(-3) == "23:57"
p time_of_day(35) == "00:35"
p time_of_day(-1437) == "00:03"
p time_of_day(3000) == "02:00"
p time_of_day(800) == "13:20"
p time_of_day(-4231) == "01:29"

# Further Exploration 3
# How would you approach this problem if you were allowed to use ruby's Date and Time classes and wanted to consider the day of week in your calculation?
# (Assume that delta_minutes is the number of minutes before or after midnight between Saturday and Sunday; in such a method, a delta_minutes value of -4231 would need to produce a return value of Thursday 01:29.)

def time_of_day(delta_minutes)
  time = Time.new(2024, 9, 29) + delta_minutes * 60
  time.strftime("%A %H:%M")
end

p time_of_day(0) == "Sunday 00:00"
p time_of_day(-3) == "Saturday 23:57"
p time_of_day(35) == "Sunday 00:35"
p time_of_day(-1437) == "Saturday 00:03"
p time_of_day(3000) == "Tuesday 02:00"
p time_of_day(800) == "Sunday 13:20"
p time_of_day(-4231) == "Thursday 01:29"
