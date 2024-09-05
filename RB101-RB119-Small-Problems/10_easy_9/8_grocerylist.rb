def buy_fruit(arr)
  arr.each_with_object([]) do |(fruit, count), newarr|
    count.times { newarr << fruit }
  end
end

p buy_fruit([["apples", 3], ["orange", 1], ["bananas", 2]]) ==
  ["apples", "apples", "apples", "orange", "bananas", "bananas"]
