def print_in_box(text)
  lines = text.length
  first = '+-'
  last = '-+'
  bar = '|'
  hyphen = '-'

  print first

  lines.times do
    print hyphen
  end
  print last
  puts ' '

  puts bar + (' ' * lines) + "  #{bar}"

  puts "#{bar} #{text} #{bar} "

  puts bar + (' ' * lines) + "  #{bar}"

  print first
  lines.times do
    print hyphen
  end

  puts last
end

print_in_box('To boldly go where no one has gone before.')
print_in_box('')
