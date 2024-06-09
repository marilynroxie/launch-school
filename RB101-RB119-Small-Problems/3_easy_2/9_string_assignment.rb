name = "Bob"
save_name = name
name.upcase!
puts name, save_name

# The code prints out 'BOB' both times # because upcase! is a destructive
# method that mutates the name variable.
