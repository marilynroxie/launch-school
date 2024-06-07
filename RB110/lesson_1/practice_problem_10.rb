[1, 2, 3].map do |num|
  if num > 1
    puts num
  else
    num
  end
end

# The block returns [1, nil, nil]. Since num > 1 is false for the first element in the array, the else statement executes and element itself is returned. For the remaining elements 2 and 3, evaluating as true, the return of puts is nil, meaning they will be transformed to nil in the new array.
# https://docs.ruby-lang.org/en/3.2/Enumerable.html#method-i-map
