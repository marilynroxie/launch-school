array1 = %w(Moe Larry Curly Shemp Harpo Chico Groucho Zeppo)
array2 = []
array1.each { |value| array2 << value }
array1.each { |value| value.upcase! if value.start_with?('C', 'S') }
puts array2

# puts array2 will print:
# CURLY
# SHEMP
# Harpo
# CHICO
# Groucho
# Zeppo
# because << is a mutating method and both array1 and array2 now have the same string elements.
