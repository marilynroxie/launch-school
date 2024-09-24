def shout_out_to(name)
  # Unnecessary and overly complicated solution
  name = name.chars.each { |c| c.upcase! }.join

  puts "HEY " + name
end

p shout_out_to("you")

# More intuitive solution!

def shout_out_to(name)
  name.upcase!

  puts "HEY " + name
end

p shout_out_to("you")
