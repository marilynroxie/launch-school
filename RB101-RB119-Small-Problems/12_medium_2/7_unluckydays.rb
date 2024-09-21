require "date"

def friday_13th(year)
  unlucky = 0
  (1..12).each do |month|
    date = Date.new(year, month, 13)
    unlucky += 1 if date.friday?
  end
  unlucky
end

p friday_13th(2015) == 3
p friday_13th(1986) == 1
p friday_13th(2019) == 2
