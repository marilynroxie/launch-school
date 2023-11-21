puts 'Enter the length of the room in meters: '
length = gets.to_f
puts 'Enter the width of the room in meters: '
width = gets.to_f
sqmt = length * width
sqft = sqmt * 10.7639
puts "The area of the room is #{sqmt} square meters (#{sqft} square feet)."
