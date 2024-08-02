DEGREE = "\u00B0"
MINUTE_SECONDS = 60
DEGREE_SECONDS = 3600

def dms(float)
  degrees = float.to_i
  decimal = float - degrees
  minutes = (decimal * MINUTE_SECONDS).to_i
  seconds = ((decimal * MINUTE_SECONDS - minutes) * 60).round
  if seconds == MINUTE_SECONDS
    seconds = 0
    minutes += 1
  elsif minutes == MINUTE_SECONDS
    minutes = 0
    degrees += 1
  end
  minutes = minutes < 10 ? "0#{minutes}" : minutes.to_s
  seconds = seconds < 10 ? "0#{seconds}" : seconds.to_s
  "#{degrees}#{DEGREE}#{minutes}'#{seconds}\""
end

puts dms(30) == %(30°00'00")
puts dms(76.73) == %(76°43'48")
puts dms(254.6) == %(254°36'00")
puts dms(93.034773) == %(93°02'05")
puts dms(0) == %(0°00'00")
puts dms(360) == %(360°00'00") || dms(360) == %(0°00'00")
