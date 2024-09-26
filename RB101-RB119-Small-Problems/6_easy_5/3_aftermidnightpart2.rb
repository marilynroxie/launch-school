require "time"

MINUTES_PER_HOUR = 60
MINUTES_PER_DAY = 1440

def after_midnight(time)
  hours, minutes = time.split(":").map { |x| x.to_i }
  (hours * MINUTES_PER_HOUR + minutes) % MINUTES_PER_DAY
end

def before_midnight(time)
  -after_midnight(time) % MINUTES_PER_DAY
end

p after_midnight("00:00") == 0
p before_midnight("00:00") == 0
p after_midnight("12:34") == 754
p before_midnight("12:34") == 686
p after_midnight("24:00") == 0
p before_midnight("24:00") == 0

# Further Exploration
# How would these methods change if you were allowed to use the Date and Time classes?

def after_midnight(time)
  time = Time.parse(time)
  (time.hour * MINUTES_PER_HOUR + time.min) % MINUTES_PER_DAY
end

def before_midnight(time)
  (MINUTES_PER_DAY - after_midnight(time)) % MINUTES_PER_DAY
end

p after_midnight("00:00") == 0
p before_midnight("00:00") == 0
p after_midnight("12:34") == 754
p before_midnight("12:34") == 686
p after_midnight("24:00") == 0
p before_midnight("24:00") == 0
