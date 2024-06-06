[1, 2, 3].select do |num|
  num > 5
  "hi"
end

# The return value of select is the new array [1, 2, 3], since "hi" is the last line within the block and "hi" evaluates to true.
