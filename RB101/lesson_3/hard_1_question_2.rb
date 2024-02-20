greetings = { a: "hi" }

informal_greeting = greetings[:a]

informal_greeting << " there"

puts informal_greeting  #  => "hi there"
puts greetings # also "hi there" because informal_greeting references the original object, the key-value pair
