def count_occurrences(vehicles)
  hash = vehicles.each_with_object(Hash.new(0)) do |key, value|
    value[key] += 1
  end

  hash.each do |key, value|
    puts "#{key} => #{value}"
  end
end

vehicles = [
  'car', 'car', 'truck', 'car', 'SUV', 'truck',
  'motorcycle', 'motorcycle', 'car', 'truck'
]

p count_occurrences(vehicles)
