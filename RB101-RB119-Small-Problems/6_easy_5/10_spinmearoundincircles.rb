def spin_me(str)
  str.split.each do |word|
    word.reverse!
  end.join(" ")
end

spin_me("hello world") # "olleh dlrow"

# The method returns a different object because of the behavior of the split method, which creates a new array object. This can be confirmed by calling object_id on the original string and on the return value of th emethod.
